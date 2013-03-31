//
//  WeightViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-23.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCAppDelegate.h"

@interface WeightViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

// Create the properties for the different weight units
@property (strong, nonatomic) NSMutableArray *pounds;
@property (strong, nonatomic) NSMutableArray *ounces;
@property (strong, nonatomic) NSMutableArray *kilograms;
@property (strong, nonatomic) NSMutableArray *grams;

// Create the outlet for the picker
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

// Create the property for the app delegate references
@property (strong, nonatomic) Preferences *preferences;
@property (strong, nonatomic) UserDetails *userdetails;

@end
