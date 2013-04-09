//
//  EntriesViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "EntriesViewController.h"

#import "Locations.h"
#import "Entries.h"
#import "EntryCell.h"
#import "EntryDetailViewController.h"

// Declare the segue name constants
static NSString* const EntryDetailViewSegueIdentifier = @"Entry Detail View";

@interface EntriesViewController ()

@end

@implementation EntriesViewController

// Synthesize the properties
@synthesize appDelegate = _appDelegate;
@synthesize preferences = _preferences;
@synthesize userdetails = _userdetails;
@synthesize symptomtypes = _symptomtypes;
@synthesize locations = _locations;
@synthesize entries = _entries;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize deleteIndex = _deleteIndex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    // Get the app delegate and user details and preferences
    self.appDelegate = (TCAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.preferences = self.appDelegate.preferences;
    self.userdetails = self.appDelegate.userdetails;
    self.symptomtypes = self.appDelegate.symptomtypes;
    self.locations = self.appDelegate.locations;
    self.entries = self.appDelegate.entries;
    self.managedObjectContext = self.appDelegate.managedObjectContext;
    self.managedObjectModel = self.appDelegate.managedObjectModel;
    self.persistentStoreCoordinator = self.appDelegate.persistentStoreCoordinator;
    
    [super viewDidLoad];
    
    // Configure the pull down to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull Down to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    // Register notification center for the changing of symptom type
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entriesListHasChanged:) name:@"EntriesListHasChanged" object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    // Reload the table data
    [self reloadTableData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    // Save the data
    [self.appDelegate saveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // We only have a single section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of entries
    return [self.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Entry Cell";

    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Entries *entry = [self.entries objectAtIndex:(([self.entries count] - indexPath.row) - 1)];
    [cell configureWithEntry:entry];
    
    return cell;
}

- (void)entriesListHasChanged:(NSNotification*)notification
{
    
    // Reload the table data
    [self reloadTableData];
}

- (void)reloadTableData
{
    
    // Load the entries
    [self.appDelegate loadEntries];
    self.entries = self.appDelegate.entries;
    
    // Reload the table data
    [self.tableView reloadData];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Check to see if the destination view is the entry detail view
    if ([segue.identifier isEqualToString:EntryDetailViewSegueIdentifier]) {
        EntryDetailViewController* controller = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        controller.currentEntry = ([self.entries count] - 1) - path.row;
        [self.tableView deselectRowAtIndexPath:path animated:NO];
    }
}


#pragma mark - Entries Support


- (void)removeEntry:(NSIndexPath *)indexPath {
    
    // Create a reference to the selected cell
    EntryCell *cell = (EntryCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    // Prepare a delete request for the entries entity
    NSEntityDescription *entryEntity = [NSEntityDescription entityForName:@"Entries"
                                                   inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entryEntity];
    
    NSError *error;
    
    // Perform the request
    NSArray *fetchedEntries = [self.managedObjectContext executeFetchRequest:request
                                                                       error:&error];
    
    // Loop through the entries and delete the selected ones
    for (NSManagedObject *entry in fetchedEntries) {
        Entries *checkEntry = (Entries *)entry;
        
        // Check to see if the entry matches the selected entry
        if (checkEntry.dateentered == cell.timeInterval) {
            [self.managedObjectContext deleteObject:entry];
            
        }
    }
    
    // Save the data
    [self.appDelegate saveData];
    
    // Load the entries
    [self.appDelegate loadEntries];
    self.entries = self.appDelegate.entries;
    
    // Delete the row
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexPaths addObject:indexPath];
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Refresh View Methods

- (void)refreshView:(UIRefreshControl *)refresh
{
    
    // Set the title for the refresh
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    // Reload the data for the table
    [self reloadTableData];
    
    // Get and format the current date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    
    // Build the updated title string
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    
    // Update the refresh title
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Check to see if the editing style is to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Create alert view to prompt the user to confirm deleting the entry
        NSString* title = @"Confirm Delete";
        NSString* message = @"Are you sure you want to delete the selected entry?";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete", nil];
        
        [alert show];
        
        // Store the index path
        self.deleteIndex = indexPath;
    }
}


#pragma mark - Alert View Delegate Methods

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // Delete the selected entry
    if (buttonIndex == 1) {
        
        // Remove the selected entry
        [self removeEntry:self.deleteIndex];
    }
}

@end
