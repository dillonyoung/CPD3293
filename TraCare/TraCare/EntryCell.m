//
//  EntryCell.m
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "EntryCell.h"

@implementation EntryCell

@synthesize timeInterval = _timeInterval;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithEntry:(Entries *)entry {
    //self.dateLabel.text = [NSString stringWithFormat:@"%f", entry.dateentered];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.dateentered];
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:date
                                                         dateStyle:NSDateFormatterLongStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    self.timeInterval = entry.dateentered;
}

@end
