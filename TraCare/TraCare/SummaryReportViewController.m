//
//  SummaryReportViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-31.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "SummaryReportViewController.h"

@interface SummaryReportViewController ()

@end

@implementation SummaryReportViewController

@synthesize appDelegate = _appDelegate;
@synthesize preferences = _preferences;
@synthesize symptomtypes = _symptomtypes;
@synthesize locations = _locations;
@synthesize entries = _entries;

@synthesize summaryType = _summaryType;
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
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Get the app delegate and user details and preferences
    self.appDelegate = (TCAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.preferences = self.appDelegate.preferences;
    self.entries = self.appDelegate.entries;
    
    
    // Set the start and end dates
    self.currentStartDate.text = [NSDateFormatter localizedStringFromDate:self.startDate
                                                                      dateStyle:NSDateFormatterLongStyle
                                                                      timeStyle:NSDateFormatterShortStyle];
    self.currentEndDate.text = [NSDateFormatter localizedStringFromDate:self.endDate
                                                                    dateStyle:NSDateFormatterLongStyle
                                                                    timeStyle:NSDateFormatterShortStyle];
    // Check to see which summary to display
    if (self.summaryType == 0) {
    
        // Declare variables
        NSDate *lowestDate;
        NSDate *highestDate;
        float lowestWeight = FLT_MAX;
        float highestWeight = FLT_MIN;
        float averageWeight = 0.0;
        int averageCount = 0;
    
        // Loop through the entries
        for (int count = 0; count < [self.entries count]; count++) {
            Entries *entry = self.entries[count];
        
            // Check to ensure the entry is between the start and end dates
            if (entry.dateentered >= [self.startDate timeIntervalSince1970] && entry.dateentered <= [self.endDate timeIntervalSince1970]) {
            
                // Check to see if the entry contained weight which was tracked
                if (entry.weight >= 0) {
                    
                    // Check to see if the entry weight is greater than the current highest weight
                    if (entry.weight > highestWeight) {
                        highestWeight = entry.weight;
                        highestDate = [NSDate dateWithTimeIntervalSince1970:entry.dateentered];
                    }
            
                    // Check to see if the entry weight is less than the current lowest weight
                    if (entry.weight < lowestWeight) {
                        lowestWeight = entry.weight;
                        lowestDate = [NSDate dateWithTimeIntervalSince1970:entry.dateentered];
                    }
                    
                    // Update the average weight
                    averageWeight += entry.weight;
                    averageCount++;
                }
            }
        }
        
        // Calculate the average weight
        averageWeight = averageWeight / averageCount;
    
        // Update the date of the highest weight
        self.currentHighestDate.text = [NSDateFormatter localizedStringFromDate:highestDate
                                                                  dateStyle:NSDateFormatterLongStyle
                                                                  timeStyle:NSDateFormatterShortStyle];

        // Update the date of the lowest weight
        self.currentLowestDate.text = [NSDateFormatter localizedStringFromDate:lowestDate
                                                                  dateStyle:NSDateFormatterLongStyle
                                                                  timeStyle:NSDateFormatterShortStyle];
        
        // Check to see which default units mode is currently selected
        if (self.preferences.defaultunits == 1) {
            
            int pounds = 0;
            int ounces = 0;
            float ouncehold = 0.0;
            
            // Update the highest weight
            ouncehold = (highestWeight * 0.035274);
            pounds = (int)(ouncehold / 16.0);
            ounces = (int)(ouncehold - (pounds * 16));
            NSString *highestValue = [NSString stringWithFormat:@"%d", pounds];
            highestValue = [highestValue stringByAppendingString:@" lbs "];
            highestValue = [highestValue stringByAppendingString:[NSString stringWithFormat:@"%d", ounces]];
            highestValue = [highestValue stringByAppendingString:@" oz"];
            self.currentHighest.text = highestValue;
            
            // Update the lowest weight
            ouncehold = (lowestWeight * 0.035274);
            pounds = (int)(ouncehold / 16.0);
            ounces = (int)(ouncehold - (pounds * 16));
            NSString *lowestValue = [NSString stringWithFormat:@"%d", pounds];
            lowestValue = [lowestValue stringByAppendingString:@" lbs "];
            lowestValue = [lowestValue stringByAppendingString:[NSString stringWithFormat:@"%d", ounces]];
            lowestValue = [lowestValue stringByAppendingString:@" oz"];
            self.currentLowest.text = lowestValue;
            
            // Update the average weight
            ouncehold = (averageWeight * 0.035274);
            pounds = (int)(ouncehold / 16.0);
            ounces = (int)(ouncehold - (pounds * 16));
            NSString *averageValue = [NSString stringWithFormat:@"%d", pounds];
            averageValue = [averageValue stringByAppendingString:@" lbs "];
            averageValue = [averageValue stringByAppendingString:[NSString stringWithFormat:@"%d", ounces]];
            averageValue = [averageValue stringByAppendingString:@" oz"];
            self.currentAverage.text = averageValue;
        } else {
            
            int kilograms = 0;
            int grams = 0;
            
            // Update the highest weight
            kilograms = (int)(highestWeight / 1000);
            grams = (int)(highestWeight - (kilograms * 1000));
            NSString *highestValue = [NSString stringWithFormat:@"%d", kilograms];
            highestValue = [highestValue stringByAppendingString:@" kg "];
            highestValue = [highestValue stringByAppendingString:[NSString stringWithFormat:@"%d", grams]];
            highestValue = [highestValue stringByAppendingString:@" g"];
            self.currentHighest.text = highestValue;
            
            // Update the lowest weight
            kilograms = (int)(lowestWeight / 1000);
            grams = (int)(lowestWeight - (kilograms * 1000));
            NSString *lowestValue = [NSString stringWithFormat:@"%d", kilograms];
            lowestValue = [lowestValue stringByAppendingString:@" kg "];
            lowestValue = [lowestValue stringByAppendingString:[NSString stringWithFormat:@"%d", grams]];
            lowestValue = [lowestValue stringByAppendingString:@" g"];
            self.currentLowest.text = lowestValue;
            
            // Update the average weight
            kilograms = (int)(averageWeight / 1000);
            grams = (int)(averageWeight - (kilograms * 1000));
            NSString *averageValue = [NSString stringWithFormat:@"%d", kilograms];
            averageValue = [averageValue stringByAppendingString:@" kg "];
            averageValue = [averageValue stringByAppendingString:[NSString stringWithFormat:@"%d", grams]];
            averageValue = [averageValue stringByAppendingString:@" g"];
            self.currentAverage.text = averageValue;
        }
        
    } else if (self.summaryType == 1) {
        
        // Declare variables
        NSDate *lowestDate;
        NSDate *highestDate;
        float lowestHours = FLT_MAX;
        float highestHours = FLT_MIN;
        float averageHours = 0.0;
        int averageCount = 0;
        
        // Loop through the entries
        for (int count = 0; count < [self.entries count]; count++) {
            Entries *entry = self.entries[count];
            
            // Check to ensure the entry is between the start and end dates
            if (entry.dateentered >= [self.startDate timeIntervalSince1970] && entry.dateentered <= [self.endDate timeIntervalSince1970]) {
                
                // Check to ensure the entry contained hours of sleep which was recorded
                if (entry.hoursofsleep >= 0) {
                    
                    // Check to see if the entry hours of sleep is greater than the current highest hours of sleep
                    if (entry.hoursofsleep > highestHours) {
                        highestHours = entry.hoursofsleep;
                        highestDate = [NSDate dateWithTimeIntervalSince1970:entry.dateentered];
                    }
                
                    // Check to see if the entry hours of sleep is less than the current lowest hours of sleep
                    if (entry.hoursofsleep < lowestHours) {
                        lowestHours = entry.hoursofsleep;
                        lowestDate = [NSDate dateWithTimeIntervalSince1970:entry.dateentered];
                    }
                    
                    // Update the average hours of sleep
                    averageHours += entry.hoursofsleep;
                    averageCount++;
                }
            }
        }
        
        // Calculate the average hours of sleep
        averageHours = averageHours / averageCount;
        
        // Update the date of the highest hours of sleep
        self.currentHighestDate.text = [NSDateFormatter localizedStringFromDate:highestDate
                                                                      dateStyle:NSDateFormatterLongStyle
                                                                      timeStyle:NSDateFormatterShortStyle];
        
        // Update the date of the lowest hours of sleep
        self.currentLowestDate.text = [NSDateFormatter localizedStringFromDate:lowestDate
                                                                     dateStyle:NSDateFormatterLongStyle
                                                                     timeStyle:NSDateFormatterShortStyle];
        
        // Update the highest hours of sleep
        NSString *highestValue = [NSString stringWithFormat:@"%.01f", highestHours];
        highestValue = [highestValue stringByAppendingString:@" Hours"];
        self.currentHighest.text = highestValue;
        
        // Update the lowest hours of sleep
        NSString *lowestValue = [NSString stringWithFormat:@"%.01f", lowestHours];
        lowestValue = [lowestValue stringByAppendingString:@" Hours"];
        self.currentLowest.text = lowestValue;
        
        // Update the average hours of sleep
        NSString *averageValue = [NSString stringWithFormat:@"%.01f", averageHours];
        averageValue = [averageValue stringByAppendingString:@" Hours"];
        self.currentAverage.text = averageValue;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.summaryType == 0) {
        switch (section) {
            case 0:
                return @"Start Date";
                break;
            case 1:
                return @"End Date";
                break;
            case 2:
                return @"Lowest Weight";
                break;
            case 3:
                return @"Highest Weight";
                break;
            case 4:
                return @"Average Weight";
                break;
            default:
                break;
        }
    } else if (self.summaryType == 1) {
        switch (section) {
            case 0:
                return @"Start Date";
                break;
            case 1:
                return @"End Date";
                break;
            case 2:
                return @"Lowest Hours of Sleep";
                break;
            case 3:
                return @"Highest Hours of Sleep";
                break;
            case 4:
                return @"Average Hours of Sleep";
                break;
            default:
                break;
        }
    }
    return @"";
}

@end
