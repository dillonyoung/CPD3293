//
//  EntryCell.h
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Entries.h"

@interface EntryCell : UITableViewCell

// Create the outlet for the date label
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

// Create the property for the time interval
@property (assign, nonatomic) NSTimeInterval timeInterval;

// Create the methods
- (void)configureWithEntry:(Entries *)entry;

@end
