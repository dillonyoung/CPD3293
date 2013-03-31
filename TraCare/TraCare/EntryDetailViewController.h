//
//  EntryDetailViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "TCAppDelegate.h"

@interface EntryDetailViewController : UITableViewController <CLLocationManagerDelegate>

// Create the property for the app delegate reference
@property (strong, nonatomic) TCAppDelegate *appDelegate;
@property (strong, nonatomic) Preferences *preferences;
@property (strong, nonatomic) UserDetails *userdetails;
@property (strong, nonatomic) NSMutableArray *symptomtypes;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *entries;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Create the outlets for the view
@property (strong, nonatomic) IBOutlet UILabel *currentWeight;
@property (strong, nonatomic) IBOutlet UILabel *currentHours;
@property (strong, nonatomic) IBOutlet UILabel *currentBloodPressureSystolic;
@property (strong, nonatomic) IBOutlet UILabel *currentBloodPressureDiastolic;
@property (strong, nonatomic) IBOutlet UILabel *currentBloodPressure;
@property (strong, nonatomic) IBOutlet UILabel *currentEnergy;
@property (strong, nonatomic) IBOutlet UILabel *currentQualitySleep;
@property (strong, nonatomic) IBOutlet UITextView *currentFitnessActivity;
@property (strong, nonatomic) IBOutlet UITextView *currentNutrition;
@property (strong, nonatomic) IBOutlet UILabel *currentSymptomType;
@property (strong, nonatomic) IBOutlet UITextView *currentSymptomDescription;
@property (strong, nonatomic) IBOutlet MKMapView *currentMap;

// Create the value arrays
@property (strong, nonatomic) NSArray *energyLevel;
@property (strong, nonatomic) NSArray *qualitySleep;

@property (assign, nonatomic) NSInteger currentEntry;

@property (strong, nonatomic) Entries *entry;

// Create the actions for the view
- (IBAction)backToEntries:(id)sender;

@end
