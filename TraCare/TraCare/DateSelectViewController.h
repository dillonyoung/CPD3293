//
//  DateSelectViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-31.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSelectViewController : UIViewController

@property (strong, nonatomic) NSDictionary *entryData;
@property (assign, nonatomic) NSDate *date;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)dateChanged:(id)sender;
@end
