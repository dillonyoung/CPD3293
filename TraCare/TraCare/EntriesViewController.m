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

static NSString* const EntryDetailViewSegueIdentifier = @"Entry Detail View";

@interface EntriesViewController ()

@end

@implementation EntriesViewController

@synthesize appDelegate = _appDelegate;
@synthesize preferences = _preferences;
@synthesize userdetails = _userdetails;
@synthesize symptomtypes = _symptomtypes;
@synthesize locations = _locations;
@synthesize entries = _entries;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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

- (void)viewWillAppear:(BOOL)animated {
    [self reloadTableData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of entries
    return [self.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Entry Cell";

    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Entries *entry = [self.entries objectAtIndex:(([self.entries count] - indexPath.row) - 1)];
    [cell configureWithEntry:entry];
    
    return cell;
}

- (void)entriesListHasChanged:(NSNotification*)notification {
    [self reloadTableData];
}

- (void)reloadTableData {
    [self loadEntries];
    [self.tableView reloadData];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:EntryDetailViewSegueIdentifier]) {
        EntryDetailViewController* controller = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSLog(@"Yes: %ld", (long)path.row);
        NSLog(@"C: %lu", (unsigned long)[self.entries count]);
        controller.currentEntry = ([self.entries count] - 1) - path.row;
        [self.tableView deselectRowAtIndexPath:path animated:NO];
    }
}


#pragma mark - Entries Support


/**
 * Loads the entries from the data file
 */
- (void)loadEntries {
    NSError *error;
    
    [self.entries removeAllObjects];
    
    // Prepare a fetch request for the entries entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entries" inManagedObjectContext:[self managedObjectContext]];
    
    // Set the entity to the entries entity
    [fetchRequest setEntity:entity];
    
    // Fetch the entries into an array
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Loop through the entries and store them in the locations class
    self.entries = [[NSMutableArray alloc] init];
    for (Entries *info in fetchedObjects) {
        [self.entries addObject:info];
    }
    
    // Inform the app that the entries list has changed
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"EntriesListHasChanged" object:self];
}


/**
 * Remove the selected entry from the data file
 */
- (void)removeEntry:(NSIndexPath *)indexPath {
    EntryCell *cell = (EntryCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    NSEntityDescription *entryEntity = [NSEntityDescription entityForName:@"Entries" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entryEntity];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateentered <= %@", cell.timeInterval];
    //[request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedEntries = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject *entry in fetchedEntries) {
        Entries *checkEntry = (Entries *)entry;
        if (checkEntry.dateentered == cell.timeInterval) {
            [self.managedObjectContext deleteObject:entry];
            
        }
        //[self.managedObjectContext deleteObject:entry];
    }
    
    [self.appDelegate saveData];
    
    [self loadEntries];
    
    // Delete the row
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexPaths addObject:indexPath];
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Refresh View Methods

- (void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    [self reloadTableData];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self removeEntry:indexPath];
        //[self.weightHistory removeWeightAtIndex:indexPath.row];
    }
}

@end
