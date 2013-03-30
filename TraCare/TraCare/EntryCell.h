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

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (assign, nonatomic) NSTimeInterval timeInterval;

- (void)configureWithEntry:(Entries *)entry;

@end
