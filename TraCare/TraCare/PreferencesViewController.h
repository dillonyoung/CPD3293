//
//  PreferencesViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-04.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencesViewController : UITableViewController

// Create the outlets for the entry tracking preferences
@property (strong, nonatomic) IBOutlet UISwitch *trackWeight;
@property (strong, nonatomic) IBOutlet UISwitch *trackSleep;
@property (strong, nonatomic) IBOutlet UISwitch *trackBloodPressure;
@property (strong, nonatomic) IBOutlet UISwitch *trackEnergyLevel;
@property (strong, nonatomic) IBOutlet UISwitch *trackQualityofSleep;
@property (strong, nonatomic) IBOutlet UISwitch *trackFitness;
@property (strong, nonatomic) IBOutlet UISwitch *trackNutrition;

// Create the outlets for the track frequency
@property (strong, nonatomic) IBOutlet UISlider *trackFrequency;

// Create the outlets for the user details

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UILabel *userGender;
@property (strong, nonatomic) IBOutlet UITextField *userWeight;
@property (strong, nonatomic) IBOutlet UITextField *userHeight;


// Create the actions for the user details
- (IBAction)changeUserName:(id)sender;
- (IBAction)changeUserWeight:(id)sender;
- (IBAction)changeUserHeight:(id)sender;

// Create the action to hide the keyboard when the user swipes down
- (IBAction)hideKeyboard:(id)sender;



@end
