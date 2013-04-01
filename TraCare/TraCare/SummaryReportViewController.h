//
//  SummaryReportViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-31.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCAppDelegate.h"

@interface SummaryReportViewController : UITableViewController

// Create the property for the app delegate reference
@property (strong, nonatomic) TCAppDelegate *appDelegate;
@property (strong, nonatomic) Preferences *preferences;
@property (strong, nonatomic) NSMutableArray *symptomtypes;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *entries;

@property (strong, nonatomic) IBOutlet UILabel *currentStartDate;
@property (strong, nonatomic) IBOutlet UILabel *currentEndDate;
@property (strong, nonatomic) IBOutlet UILabel *currentLowest;
@property (strong, nonatomic) IBOutlet UILabel *currentHighest;
@property (strong, nonatomic) IBOutlet UILabel *currentAverage;
@property (strong, nonatomic) IBOutlet UILabel *currentLowestDate;
@property (strong, nonatomic) IBOutlet UILabel *currentHighestDate;


@property (assign, nonatomic) NSInteger summaryType;

@property (assign, nonatomic) NSDate *startDate;
@property (assign, nonatomic) NSDate *endDate;

@end
