//
//  SummaryViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "SummaryViewController.h"

#import "DateSelectViewController.h"
#import "SummaryTypeViewController.h"
#import "SummaryReportViewController.h"

static NSString* const StartDateViewSegueIdentifier = @"Start Date Select View";
static NSString* const EndDateViewSegueIdentifier = @"End Date Select View";
static NSString* const SummaryTypeViewSegueIdentifier = @"Summary Type Select View";
static NSString* const SummaryReportViewSegueIdentifier = @"Summary Report Select View";

@interface SummaryViewController ()

@end

@implementation SummaryViewController

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize selectedType = _selectedType;

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
    
    // Register notification center for the changing summary type
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(summaryTypeHasChange:) name:@"SummaryTypeHasChanged" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateSelectedSummaryType];
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

- (void)summaryTypeHasChange:(NSNotification *)notification {

    // Get the dictionary
    NSDictionary *entryData = [notification userInfo];
    NSString *value = [entryData valueForKey:@"Value"];
    self.selectedType = [value integerValue];
}

- (void)updateSelectedSummaryType {
    switch (self.selectedType) {
        case 0:
            self.currentType.text = @"Weight";
            break;
        case 1:
            self.currentType.text = @"Hours of Sleep";
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:StartDateViewSegueIdentifier]) {
        DateSelectViewController* controller = segue.destinationViewController;
        controller.title = @"Start Date";
        NSMutableDictionary *entryData = [[NSMutableDictionary alloc] init];
        [entryData setObject:@"Start" forKey:@"Field"];
        controller.entryData = entryData;
        controller.startDate = self.startDate;
        controller.endDate = self.endDate;
    } else if ([segue.identifier isEqualToString:EndDateViewSegueIdentifier]) {
        DateSelectViewController* controller = segue.destinationViewController;
        controller.title = @"End Date";
        NSMutableDictionary *entryData = [[NSMutableDictionary alloc] init];
        [entryData setObject:@"End" forKey:@"Field"];
        controller.entryData = entryData;
        controller.startDate = self.startDate;
        controller.endDate = self.endDate;
    } else if ([segue.identifier isEqualToString:SummaryTypeViewSegueIdentifier]) {
        SummaryTypeViewController* controller = segue.destinationViewController;
        controller.selectedIndex = self.selectedType;
    } else if ([segue.identifier isEqualToString:SummaryReportViewSegueIdentifier]) {
        SummaryReportViewController* controller = segue.destinationViewController;
        
        controller.startDate = self.startDate;
        controller.endDate = self.endDate;
        controller.summaryType = self.selectedType;
        
        switch (self.selectedType) {
            case 0:
                controller.title = @"Weight";
                break;
            case 1:
                controller.title = @"Hours of Sleep";
                break;
            default:
                break;
        }
    }
}

@end
