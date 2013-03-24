//
//  HeightViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-24.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCAppDelegate.h"

@interface HeightViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

// Create the properties for the different weight units
@property (strong, nonatomic) NSMutableArray *feet;
@property (strong, nonatomic) NSMutableArray *inches;
@property (strong, nonatomic) NSMutableArray *meters;
@property (strong, nonatomic) NSMutableArray *centimeters;

// Create the outlet for the picker
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

// Create the property for the app delegate references
@property (strong, nonatomic) Preferences *preferences;
@property (strong, nonatomic) UserDetails *userdetails;

@end
