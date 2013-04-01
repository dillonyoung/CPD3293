//
//  SummaryViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *currentType;
@property (strong, nonatomic) IBOutlet UILabel *currentStartDate;
@property (strong, nonatomic) IBOutlet UILabel *currentEndDate;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) NSInteger selectedType;

@end
