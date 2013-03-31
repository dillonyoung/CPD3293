//
//  EntryDetailViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "EntryDetailViewController.h"

@interface EntryDetailViewController ()

@end

@implementation EntryDetailViewController

@synthesize appDelegate = _appDelegate;
@synthesize preferences = _preferences;
@synthesize userdetails = _userdetails;
@synthesize symptomtypes = _symptomtypes;
@synthesize locations = _locations;
@synthesize entries = _entries;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize currentEntry = _currentEntry;

@synthesize energyLevel = _energyLevel;
@synthesize qualitySleep = _qualitySleep;

@synthesize entry = _entry;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {

    [self.appDelegate loadEntries];
    self.entries = self.appDelegate.entries;
    
    [self.appDelegate loadLocations];
    self.locations = self.appDelegate.locations;
    
    self.entry = self.entries[self.currentEntry];
    
    // Check to see if the weight was tracked when the entry was made
    if (self.entry.weight >= 0) {
        
        // Check to see which default units mode is currently selected
        if (self.preferences.defaultunits == 1) {
            float ouncehold = (self.entry.weight * 0.035274);
            int pounds = (int)(ouncehold / 16.0);
            int ounces = (int)(ouncehold - (pounds * 16.0));
            NSString *value = [NSString stringWithFormat:@"%d", pounds];
            value = [value stringByAppendingString:@" lbs "];
            value = [value stringByAppendingString:[NSString stringWithFormat:@"%d", ounces]];
            value = [value stringByAppendingString:@" oz"];
            self.currentWeight.text = value;
        } else {
            int kilograms = (int)(self.entry.weight / 1000);
            int grams = (int)(self.entry.weight - (kilograms * 1000));
            NSString *value = [NSString stringWithFormat:@"%d", kilograms];
            value = [value stringByAppendingString:@" kg "];
            value = [value stringByAppendingString:[NSString stringWithFormat:@"%d", grams]];
            value = [value stringByAppendingString:@" g"];
            self.currentWeight.text = value;
        }
    }
    
    // Check to see if the hours of sleep was tracked when the entry was made
    if (self.entry.hoursofsleep >= 0) {
    
        // Update the hours of sleep
        NSString *value = [NSString stringWithFormat:@"%.01f", self.entry.hoursofsleep];
        value = [value stringByAppendingString:@" Hours"];
        self.currentHours.text = value;
    }
    
    // Check to see if the blood pressure was tracked when the entry was made
    if (self.entry.bloodpressurediastolic >= 0) {
    
        // Update the blood pressure
        int systolic = self.entry.bloodpressuresystolic;
        int diastolic = self.entry.bloodpressurediastolic;
        NSString *bpvalue = [NSString stringWithFormat:@"%d", systolic];
        bpvalue = [bpvalue stringByAppendingString:@" / "];
        bpvalue = [bpvalue stringByAppendingString:[NSString stringWithFormat:@"%d", diastolic]];
        self.currentBloodPressure.text = bpvalue;
        self.currentBloodPressureSystolic.text = [NSString stringWithFormat:@"%d", systolic];
        self.currentBloodPressureDiastolic.text = [NSString stringWithFormat:@"%d", diastolic];
    }
    
    // Check to see if the energy level was tracked when the entry was made
    if (self.entry.energylevel >= 0) {
    
        // Update the energy level
        self.currentEnergy.text = [self.energyLevel objectAtIndex:self.entry.energylevel];
    }

    // Check to see if the quality of sleep was tracked when the entry was made
    if (self.entry.qualityofsleep >= 0) {
    
        // Update the quality of sleep
        self.currentQualitySleep.text = [self.qualitySleep objectAtIndex:self.entry.qualityofsleep];
    }

    // Check to see if the fitness activity was tracked when the entry was made
    if (![self.entry.fitnessactivity isEqual: @"<{[blank]}>"]) {
    
        // Update the fitness activity
        self.currentFitnessActivity.text = self.entry.fitnessactivity;
    }
    
    // Check to see if the nutrition was tracked when the entry was made
    if (![self.entry.nutrition isEqual:@"<{[blank]}>"]) {
    
        // Update the nutrition
        self.currentNutrition.text = self.entry.nutrition;
    }
    
    // Check to see if the symptoms was tracked when the entry was made
    if (![self.entry.symptomdescription isEqual:@"<{[blank]}>"]) {
    
        // Update the symptoms
        self.currentSymptomDescription.text = self.entry.symptomdescription;
        SymptomTypes *info = self.symptomtypes[self.entry.symptomtype];
        self.currentSymptomType.text = info.symptomdesc;
    }
    
    // Update the view title
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.entry.dateentered];
    self.title = [NSDateFormatter localizedStringFromDate:date
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Check to see if the location was tracked when the entry was made
    if (self.entry.location >= 0) {
    
        // Update the map with the location for the entry
        Locations *location = self.locations[self.entry.location];

        if (location.latitude == 0 && location.longitude == 0) {
        
            // No location recorded
        
        } else {
        
            // Create a location
            CLLocationCoordinate2D entryLocation;
            entryLocation.latitude = location.latitude;
            entryLocation.longitude = location.longitude;
        
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = entryLocation;
        
            [self.currentMap addAnnotation:point];
        
            // Adjust the map zoom
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(point.coordinate, 50, 50);
            MKCoordinateRegion adjustedRegion = [self.currentMap regionThatFits:viewRegion];
            [self.currentMap setRegion:adjustedRegion animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToEntries:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Check to see which section is selected
    switch (section) {
            
        // Check to see if the section is the weight section
        case 0:
            
            // Check to see if the section rows should be displayed
            if (self.entry.weight >= 0) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.entry.hoursofsleep >= 0) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.entry.bloodpressurediastolic >= 0) {
                return 3;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.entry.energylevel >= 0) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.entry.qualityofsleep >= 0) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if (![self.entry.fitnessactivity isEqual:@"<{[blank]}>"]) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the nutrion
        case 6:
            
            // Check to see if the section rows should be displayed
            if (![self.entry.nutrition isEqual:@"<{[blank]}>"]) {
                return 1;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if (![self.entry.symptomdescription isEqual:@"<{[blank]}>"]) {
                return 2;
            } else {
                return 0;
            }
            break;
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.entry.location >= 0) {
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
            if (self.entry.weight == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.entry.hoursofsleep == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.entry.bloodpressurediastolic == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.entry.energylevel == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.entry.qualityofsleep == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.fitnessactivity isEqual:@"<{[blank]}>"]) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the nutrition
        case 6:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.nutrition isEqual:@"<{[blank]}>"]) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.symptomdescription isEqual:@"<{[blank]}>"]) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.entry.location == -1) {
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
            if (self.entry.weight == -1) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.entry.hoursofsleep == -1) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.entry.bloodpressurediastolic == -1) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.entry.energylevel == -1) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.entry.qualityofsleep == -1) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.fitnessactivity isEqual:@"<{[blank]}>"]) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the nutrition
        case 6:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.nutrition isEqual:@"<{[blank]}>"]) {
                return 1;
            } else {
                return 32;
            }
            break;
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.symptomdescription isEqual:@"<{[blank]}>"]) {
                return 1;
            } else {
                return 32;
            }
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.entry.location == -1) {
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
            if (self.entry.weight == -1) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.entry.hoursofsleep == -1) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.entry.bloodpressurediastolic == -1) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.entry.energylevel == -1) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.entry.qualityofsleep == -1) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.fitnessactivity isEqual:@"<{[blank]}>"]) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the nutrition
        case 6:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.nutrition isEqual:@"<{[blank]}>"]) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.symptomdescription isEqual:@"<{[blank]}>"]) {
                return 1;
            } else {
                return 16;
            }
            break;
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.entry.location == -1) {
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
            if (self.entry.weight == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the hours of sleep
        case 1:
            
            // Check to see if the section rows should be displayed
            if (self.entry.hoursofsleep == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the blood pressure
        case 2:
            
            // Check to see if the section rows should be displayed
            if (self.entry.bloodpressurediastolic == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the energy level
        case 3:
            
            // Check to see if the section rows should be displayed
            if (self.entry.energylevel == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the quality of sleep
        case 4:
            
            // Check to see if the section rows should be displayed
            if (self.entry.qualityofsleep == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            break;
            
        // Check to see if the section is the fitness activity
        case 5:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.fitnessactivity isEqual:@"<{[blank]}>"]) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            
        // Check to see if the section is the nutrition
        case 6:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.nutrition isEqual:@"<{[blank]}>"]) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            
        // Check to see if the section is the symptoms
        case 7:
            
            // Check to see if the section rows should be displayed
            if ([self.entry.symptomdescription isEqual:@"<{[blank]}>"]) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
            
        // Check to see if the section is the location
        case 8:
            
            // Check to see if the section rows should be displayed
            if (self.entry.location == -1) {
                return [[UIView alloc] initWithFrame:CGRectZero];
            } else {
                return nil;
            }
        default:
            break;
    }
    return  nil;
}
@end
