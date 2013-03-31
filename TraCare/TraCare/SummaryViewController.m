//
//  SummaryViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "SummaryViewController.h"

#import "DateSelectViewController.h"

static NSString* const StartDateViewSegueIdentifier = @"Start Date Select View";
static NSString* const EndDateViewSegueIdentifier = @"End Date Select View";

@interface SummaryViewController ()

@end

@implementation SummaryViewController

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

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
    [super viewDidLoad];
    
    // Set the end date
    self.endDate = [NSDate date];
    self.currentEndDate.text = [NSDateFormatter localizedStringFromDate:self.endDate
                                                dateStyle:NSDateFormatterLongStyle
                                                timeStyle:NSDateFormatterShortStyle];
    
    // Set the start date
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-7];
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    self.startDate = date;
    self.currentStartDate.text = [NSDateFormatter localizedStringFromDate:self.startDate
                                                              dateStyle:NSDateFormatterLongStyle
                                                              timeStyle:NSDateFormatterShortStyle];
    
    // Register notification center for the changing date
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateHasChanged:) name:@"DateHasChanged" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)dateHasChanged:(NSNotification *)notification {
    
    // Get the dictionary
    NSDictionary *entryData = [notification userInfo];
    
    // Check to see which field needs to be updated
    if ([[entryData valueForKey:@"Field"] isEqual:@"Start"]) {
        self.startDate = [entryData valueForKey:@"Date"];
        NSLog(@"Yes: %@", self.startDate);
        self.currentStartDate.text = [NSDateFormatter localizedStringFromDate:self.startDate
                                                                    dateStyle:NSDateFormatterLongStyle
                                                                    timeStyle:NSDateFormatterShortStyle];
    } else if ([[entryData valueForKey:@"Field"] isEqual:@"End"]) {
        self.endDate = [entryData valueForKey:@"Date"];
        self.currentEndDate.text = [NSDateFormatter localizedStringFromDate:self.endDate
                                                                    dateStyle:NSDateFormatterLongStyle
                                                                    timeStyle:NSDateFormatterShortStyle];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:StartDateViewSegueIdentifier]) {
        DateSelectViewController* controller = segue.destinationViewController;
        controller.title = @"Start Date";
        NSMutableDictionary *entryData = [[NSMutableDictionary alloc] init];
        [entryData setObject:@"Start" forKey:@"Field"];
        controller.entryData = entryData;
        controller.date = self.startDate;
    } else if ([segue.identifier isEqualToString:EndDateViewSegueIdentifier]) {
        DateSelectViewController* controller = segue.destinationViewController;
        controller.title = @"End Date";
        NSMutableDictionary *entryData = [[NSMutableDictionary alloc] init];
        [entryData setObject:@"End" forKey:@"Field"];
        controller.entryData = entryData;
        controller.date = self.endDate;
    }
}

@end
