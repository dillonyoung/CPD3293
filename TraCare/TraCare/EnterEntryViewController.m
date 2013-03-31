//
//  EnterEntryViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-04.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "EnterEntryViewController.h"
#import "TextEntryViewController.h"
#import "SymptomTypeViewController.h"
#import "Locations.h"
#import "Entries.h"

static NSString* const NewEntryFitnessActivityViewSegueIdentifier = @"New Entry Fitness Activity";
static NSString* const NewEntryNutritionViewSegueIdentifier = @"New Entry Nutrition";
static NSString* const NewEntrySymptomsViewSegueIdentifier = @"New Entry Symptoms";
static NSString* const NewEntrySymptomsTypeViewSegueIdentifier = @"New Entry Symptoms Type";

@interface EnterEntryViewController ()

@end

@implementation EnterEntryViewController {
    CLLocationManager *locationManager;
}

@synthesize appDelegate = _appDelegate;
@synthesize preferences = _preferences;
@synthesize userdetails = _userdetails;
@synthesize symptomtypes = _symptomtypes;
@synthesize locations = _locations;
@synthesize entries = _entries;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize mapview = _mapview;

@synthesize energyLevel = _energyLevel;
@synthesize qualitySleep = _qualitySleep;

@synthesize currentLocation = _currentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    // Initialize the energy level array
    self.energyLevel = [[NSArray alloc] initWithObjects:@"Not Specified", @"Terrible", @"Poor", @"Average", @"Good", @"Excellent", nil];
    
    // Initialize the quality of sleep array
    self.qualitySleep = [[NSArray alloc] initWithObjects:@"Not Specified", @"Terrible", @"Poor", @"Average", @"Good", @"Excellent", nil];
    
    // Register notification center for the changing of text values
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEntryHasChanged:) name:@"TextEntryHasChanged" object:nil];
    
    // Register notification center for the changing of symptom type
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(symptomTypeHasChanged:) name:@"SymptomTypeHasChanged" object:nil];
    
    // Get the app delegate and user details and preferences
    self.appDelegate = (TCAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.preferences = self.appDelegate.preferences;
    self.userdetails = self.appDelegate.userdetails;
    self.symptomtypes = self.appDelegate.symptomtypes;
    self.locations = self.appDelegate.locations;
    self.entries = self.appDelegate.entries;
    self.managedObjectContext = self.appDelegate.managedObjectContext;
    self.managedObjectModel = self.appDelegate.managedObjectModel;
    self.persistentStoreCoordinator = self.appDelegate.persistentStoreCoordinator;
    
    // Set initial values
    if (self.preferences.defaultunits == 1) {
        self.stepWeight.minimumValue = 16;
        self.stepWeight.maximumValue = 6399;
        float ouncehold = self.userdetails.weight * 0.035274;
        self.stepWeight.value = ouncehold;
        [self changeWeight:self];
    } else {
        self.stepWeight.minimumValue = 1000;
        self.stepWeight.maximumValue = 199999;
        self.stepWeight.stepValue = 5;
        self.stepWeight.value = self.userdetails.weight;
        [self changeWeight:self];
    }
    
    self.currentSymptomDescription.text = @"";
    self.currentNutrition.text = @"";
    self.currentFitnessActivity.text = @"";
    
    [self changeBloodPressureDiastolic:self];
    
    SymptomTypes *info = self.symptomtypes[0];
    self.currentSymptomType.text = info.symptomdesc;
    
    self.stepEnergyLevel.minimumValue = 0;
    self.stepEnergyLevel.maximumValue = [self.energyLevel count] - 1;
    self.stepEnergyLevel.value = 0;
    self.currentEnergyLevel.text = [self.energyLevel objectAtIndex:self.stepEnergyLevel.value];
    
    self.stepQualitySleep.minimumValue = 0;
    self.stepQualitySleep.maximumValue = [self.qualitySleep count] - 1;
    self.stepQualitySleep.value = 0;
    self.currentQualitySleep.text = [self.qualitySleep objectAtIndex:self.stepQualitySleep.value];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    if (self.preferences.location) {
        // Initialize the location manager
        locationManager = [[CLLocationManager alloc] init];
    
        // Get the location
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Update the display with the current values
    [self changeHours:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelEntry:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Check to see which section is selected
    switch (section) {
        
        // Check to see if the section is the weight section
        case 0:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.weight == YES) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.sleep == YES) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.bloodpressure == YES) {
                return 3;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.energy == YES) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.qualityofsleep == YES) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.fitness == YES) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the nutrion
        case 6:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.nutrition == YES) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.symptom == YES) {
                return 2;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.location == YES) {
                return 1;
            } else {
                return 0;
            }
            break;
        default:
            break;
    }
    return  1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    // Check to see which section is selected
    switch (section) {

        // Check to see if the section is the weight section
        case 0:
            // Check to see if the section rows should be displayed
            if (self.preferences.weight == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.sleep == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.bloodpressure == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.energy == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.qualityofsleep == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.fitness == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the nutrition
        case 6:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.nutrition == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.symptom == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.location == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
        default:
            break;
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    // Check to see which section is selected
    switch (section) {
            
        // Check to see if the section is the weight section
        case 0:
            // Check to see if the section rows should be displayed
            if (self.preferences.weight == NO) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.sleep == NO) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.bloodpressure == NO) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.energy == NO) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.qualityofsleep == NO) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.fitness == NO) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the nutrition
        case 6:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.nutrition == NO) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.symptom == NO) {
                return 1;
            } else {
                return 32;
            }
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.location == NO) {
                return 1;
            } else {
                return 32;
            }
            break;
        default:
            break;
    }
    return  32;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    // Check to see which section is selected
    switch (section) {
            
        // Check to see if the section is the weight section
        case 0:
            // Check to see if the section rows should be displayed
            if (self.preferences.weight == NO) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.sleep == NO) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.bloodpressure == NO) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.energy == NO) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.qualityofsleep == NO) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.fitness == NO) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the nutrition
        case 6:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.nutrition == NO) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.symptom == NO) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.location == NO) {
                return 1;
            } else {
                return 16;
            }
            break;
        default:
            break;
    }
    return  32;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    // Check to see which section is selected
    switch (section) {
            
        // Check to see if the section is the weight section
        case 0:
            // Check to see if the section rows should be displayed
            if (self.preferences.weight == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.sleep == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.bloodpressure == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.energy == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.qualityofsleep == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.fitness == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            
        // Check to see if the section is the nutrition
        case 6:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.nutrition == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.symptom == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.preferences.location == NO) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
        default:
            break;
    }
    return  nil;
}

- (IBAction)changeWeight:(id)sender {
    
    // Check to see which default units mode is currently selected
    if (self.preferences.defaultunits == 1) {
        int pounds = (int)(self.stepWeight.value / 16.0);
        int ounces = (int)(self.stepWeight.value - (pounds* 16));
        NSString *value = [NSString stringWithFormat:@"%d", pounds];
        value = [value stringByAppendingString:@" lbs "];
        value = [value stringByAppendingString:[NSString stringWithFormat:@"%d", ounces]];
        value = [value stringByAppendingString:@" oz"];
        self.currentWeight.text = value;
    } else {
        int kilograms = (int)(self.stepWeight.value / 1000);
        int grams = (int)(self.stepWeight.value - (kilograms * 1000));
        NSString *value = [NSString stringWithFormat:@"%d", kilograms];
        value = [value stringByAppendingString:@" kg "];
        value = [value stringByAppendingString:[NSString stringWithFormat:@"%d", grams]];
        value = [value stringByAppendingString:@" g"];
        self.currentWeight.text = value;
    }
}

- (IBAction)changeHours:(id)sender {
    
    // Update the hours of sleep
    NSString *value = [NSString stringWithFormat:@"%.01f", self.stepHours.value];
    value = [value stringByAppendingString:@" Hours"];
    self.currentHours.text = value;
}

- (IBAction)changeBloodPressureSystolic:(id)sender {
    [self updateBloodPressureDisplay];
}

- (IBAction)changeBloodPressureDiastolic:(id)sender {
    [self updateBloodPressureDisplay];
}

- (IBAction)changeEnergyLevel:(id)sender {
    self.currentEnergyLevel.text = [self.energyLevel objectAtIndex:self.stepEnergyLevel.value];
}

- (IBAction)changeQualitySleep:(id)sender {
    self.currentQualitySleep.text = [self.qualitySleep objectAtIndex:self.stepQualitySleep.value];
}

- (IBAction)saveNewEntry:(id)sender {
    
    NSError *error;
    
    // Create a new locations instance
    NSInteger locationIndex;
    
    // Check to see if the location should be saved
    if (self.preferences.location) {
        locationIndex = [self checkForLocation:self.currentLocation];

        if (locationIndex == -1) {
            locationIndex = [self addNewLocation:self.currentLocation];
        }
    } else {
        locationIndex = -1;
    }
    
    // Create an new entry instance
    Entries *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Entries" inManagedObjectContext:[self managedObjectContext]];
    
    // Check to see if the weight should be saved
    if (self.preferences.weight) {
        
        // Check to see which default units mode is selected and get the weight
        if (self.preferences.defaultunits == 1) {
            float ounces = self.stepWeight.value;
            float grams = ounces / 0.035274;
            newEntry.weight = grams;
        } else {
            float grams = self.stepWeight.value;
            newEntry.weight = grams;
        }
    } else {
        newEntry.weight = -1;
    }
    
    // Check to see if the hours of sleep should be saved
    if (self.preferences.sleep) {
        newEntry.hoursofsleep = self.stepHours.value;
    } else {
        newEntry.hoursofsleep = -1;
    }

    // Check to see if the blood pressure should be saved
    if (self.preferences.bloodpressure) {
        newEntry.bloodpressuresystolic = self.stepBloodPressureSystolic.value;
        newEntry.bloodpressurediastolic = self.stepBloodPressureDiastolic.value;
    } else {
        newEntry.bloodpressuresystolic = -1;
        newEntry.bloodpressurediastolic = -1;
    }

    // Check to see if the energy level should be saved
    if (self.preferences.energy) {
        newEntry.energylevel = self.stepEnergyLevel.value;
    } else {
        newEntry.energylevel = -1;
    }
    
    // Check to see if the quality of sleep should be saved
    if (self.preferences.qualityofsleep) {
        newEntry.qualityofsleep = self.stepQualitySleep.value;
    } else {
        newEntry.qualityofsleep = -1;
    }
    
    // Check to see if the fitness acitivity should be saved
    if (self.preferences.fitness) {
        newEntry.fitnessactivity = self.currentFitnessActivity.text;
    } else {
        newEntry.fitnessactivity = @"<{[blank]}>";
    }
    
    // Check to see if the nutrition should be saved
    if (self.preferences.nutrition) {
        newEntry.nutrition = self.currentNutrition.text;
    } else {
        newEntry.nutrition = @"<{[blank]}>";
    }
    
    // Check to see if the symptoms should be checked
    if (self.preferences.symptom) {
        newEntry.symptomdescription = self.currentSymptomDescription.text;
    
        for (int count = 0; count < [self.symptomtypes count]; count++) {
            if ([self.currentSymptomType.text isEqualToString:[self.symptomtypes[count] symptomdesc]]) {
                newEntry.symptomtype = count;
            }
        }
    } else {
        newEntry.symptomdescription = @"<{[blank]}>";
        newEntry.symptomtype = -1;
    }
    
    // Get the location
    newEntry.location = locationIndex;
    
    // Get the date
    newEntry.dateentered =  [[NSDate date] timeIntervalSince1970];
    
    // Attempt to save the entry
    if( ! [[self managedObjectContext] save:&error] ){
        NSLog(@"Cannot save data: %@", [error localizedDescription]);
    }
    
    // Inform the app that the entries list has changed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EntriesListHasChanged" object:self];
    
    // Navigate back to the entries list
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)checkForLocation:(CLLocation*)location {
    NSInteger index = -1;

    for (int count = 0; count < [self.locations count]; count++) {
        if ([self.locations[count] latitude] == location.coordinate.latitude && [self.locations[count] longitude] == location.coordinate.longitude) {
            index = count;
        }
    }
    
    return index;
}

- (NSInteger)addNewLocation:(CLLocation*)location {
    
    NSError *error;
    
    // Create a new location entry
    Locations *newlocation = [NSEntityDescription insertNewObjectForEntityForName:@"Locations" inManagedObjectContext:[self managedObjectContext]];
    
    newlocation.index = [self.locations count];
    newlocation.latitude = location.coordinate.latitude;
    newlocation.longitude = location.coordinate.longitude;

    // Attempt to save the location
    if( ! [[self managedObjectContext] save:&error] ){
        NSLog(@"Cannot save data: %@", [error localizedDescription]);
    }
    
    [self.appDelegate loadLocations];

    return [self.locations count] - 1;
}

/**
 * Hides the keyboard
 */
- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}


- (void)updateBloodPressureDisplay {
    int systolic = self.stepBloodPressureSystolic.value;
    int diastolic = self.stepBloodPressureDiastolic.value;
    NSString *value = [NSString stringWithFormat:@"%d", systolic];
    value = [value stringByAppendingString:@" / "];
    value = [value stringByAppendingString:[NSString stringWithFormat:@"%d", diastolic]];
    self.currentBloodPressure.text = value;
}

- (void)textEntryHasChanged:(NSNotification*)notification {
    
    // Get the dictionary
    NSDictionary *entryData = [notification userInfo];
    
    // Check to see which field needs to be updated
    if ([[entryData valueForKey:@"Field"] isEqual:@"Fitness Activity"]) {
        self.currentFitnessActivity.text = [entryData valueForKey:@"Text"];
    } else if ([[entryData valueForKey:@"Field"] isEqual:@"Nutrition"]) {
        self.currentNutrition.text = [entryData valueForKey:@"Text"];
    } else if ([[entryData valueForKey:@"Field"] isEqual:@"Symptoms"]) {
        self.currentSymptomDescription.text = [entryData valueForKey:@"Text"];
    }
}

- (void)symptomTypeHasChanged:(NSNotification*)notification {
    
    // Get the dictionary
    NSDictionary *entryData = [notification userInfo];
    
    // Update the symptom type label
    int value = [[entryData valueForKey:@"Symptom"] intValue];
    SymptomTypes *info = self.symptomtypes[value];
    self.currentSymptomType.text = info.symptomdesc;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:NewEntryFitnessActivityViewSegueIdentifier]) {
        TextEntryViewController* controller = segue.destinationViewController;
        NSMutableDictionary *entryData = [[NSMutableDictionary alloc] init];
        [entryData setObject:@"Fitness Activity" forKey:@"Field"];
        [entryData setObject:self.currentFitnessActivity.text forKey:@"Text"];
        controller.entryData = entryData;
    } else if ([segue.identifier isEqual:NewEntryNutritionViewSegueIdentifier]) {
        TextEntryViewController* controller = segue.destinationViewController;
        NSMutableDictionary *entryData = [[NSMutableDictionary alloc] init];
        [entryData setObject:@"Nutrition" forKey:@"Field"];
        [entryData setObject:self.currentNutrition.text forKey:@"Text"];
        controller.entryData = entryData;
    } else if ([segue.identifier isEqual:NewEntrySymptomsViewSegueIdentifier]) {
        TextEntryViewController* controller = segue.destinationViewController;
        NSMutableDictionary *entryData = [[NSMutableDictionary alloc] init];
        [entryData setObject:@"Symptoms" forKey:@"Field"];
        [entryData setObject:self.currentSymptomDescription.text forKey:@"Text"];
        controller.entryData = entryData;
    } else if ([segue.identifier isEqual:NewEntrySymptomsTypeViewSegueIdentifier]) {
        SymptomTypeViewController* controller = segue.destinationViewController;
        controller.symptomTypes = self.symptomtypes;
        for (int count = 0; count < [self.symptomtypes count]; count++) {
            SymptomTypes *item = self.symptomtypes[count];
            if ([item.symptomdesc isEqualToString:self.currentSymptomType.text]) {
                controller.symptomIndex = count;
            }
        }
    }
}


#pragma mark - Location Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);

    // Remove all previous annotations
    for (id annotation in self.mapview.annotations) {
        [self.mapview removeAnnotation:annotation];
    }
    
    // Create an invalid location
    CLLocationCoordinate2D errorLocation;
    errorLocation.longitude = 0;
    errorLocation.longitude = 0;
    
    // Adjust the map zoom
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(errorLocation, 475 * 1000, 475 * 1000);
    MKCoordinateRegion adjustedRegion = [self.mapview regionThatFits:viewRegion];
    [self.mapview setRegion:adjustedRegion animated:YES];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    // Loop through the locations
    for (int count = 0; count < [locations count]; count++) {
        
        // Update the current location
        self.currentLocation = locations[count];
        
        // Build the map annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = self.currentLocation.coordinate;
        
        // Remove all previous annotations
        for (id annotation in self.mapview.annotations) {
            [self.mapview removeAnnotation:annotation];
        }
        
        // Add the new annotation
        [self.mapview addAnnotation:point];
        
        // Adjust the map zoom
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(point.coordinate, 50, 50);
        MKCoordinateRegion adjustedRegion = [self.mapview regionThatFits:viewRegion];
        [self.mapview setRegion:adjustedRegion animated:YES];
    }
}
@end
