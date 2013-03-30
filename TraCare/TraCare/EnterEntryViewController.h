//
//  EnterEntryViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-04.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "TCAppDelegate.h"

@interface EnterEntryViewController : UITableViewController <CLLocationManagerDelegate>

// Create the property for the app delegate reference
@property (strong, nonatomic) TCAppDelegate *appDelegate;
@property (strong, nonatomic) Preferences *preferences;
@property (strong, nonatomic) UserDetails *userdetails;
@property (strong, nonatomic) NSMutableArray *symptomtypes;

- (IBAction)cancelEntry:(id)sender;

// Create the outlet for the map view
@property (strong, nonatomic) IBOutlet MKMapView *mapview;

// Create the outlets for the view labels
@property (strong, nonatomic) IBOutlet UILabel *currentWeight;
@property (strong, nonatomic) IBOutlet UILabel *currentHours;
@property (strong, nonatomic) IBOutlet UILabel *currentEnergyLevel;
@property (strong, nonatomic) IBOutlet UILabel *currentQualitySleep;
@property (strong, nonatomic) IBOutlet UILabel *currentBloodPressure;
@property (strong, nonatomic) IBOutlet UILabel *currentFitnessActivity;
@property (strong, nonatomic) IBOutlet UILabel *currentNutrition;
@property (strong, nonatomic) IBOutlet UILabel *currentSymptomDescription;
@property (strong, nonatomic) IBOutlet UILabel *currentSymptomType;

// Create the outlets for the steppers
@property (strong, nonatomic) IBOutlet UIStepper *stepWeight;
@property (strong, nonatomic) IBOutlet UIStepper *stepHours;
@property (strong, nonatomic) IBOutlet UIStepper *stepBloodPressureSystolic;
@property (strong, nonatomic) IBOutlet UIStepper *stepBloodPressureDiastolic;
@property (strong, nonatomic) IBOutlet UIStepper *stepEnergyLevel;
@property (strong, nonatomic) IBOutlet UIStepper *stepQualitySleep;

// Create the value arrays
@property (strong, nonatomic) NSArray *energyLevel;
@property (strong, nonatomic) NSArray *qualitySleep;

// Create the property for the current location
@property (strong, nonatomic) CLLocation *currentLocation;

// Create the actions
- (IBAction)changeWeight:(id)sender;
- (IBAction)changeHours:(id)sender;
- (IBAction)changeBloodPressureSystolic:(id)sender;
- (IBAction)changeBloodPressureDiastolic:(id)sender;
- (IBAction)changeEnergyLevel:(id)sender;
- (IBAction)changeQualitySleep:(id)sender;

- (IBAction)hideKeyboard:(id)sender;

@end
