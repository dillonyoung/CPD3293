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

@implementation EntryDetailViewController {
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
    
    // Initialize the location manager
    locationManager = [[CLLocationManager alloc] init];
    
    // Get the location
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //[locationManager startUpdatingLocation];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {

    [self loadEntries];
    
    self.entry = self.entries[self.currentEntry];
    
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
    
    // Update the hours of sleep
    NSString *value = [NSString stringWithFormat:@"%.01f", self.entry.hoursofsleep];
    value = [value stringByAppendingString:@" Hours"];
    self.currentHours.text = value;
    
    // Update the blood pressure
    int systolic = self.entry.bloodpressuresystolic;
    int diastolic = self.entry.bloodpressurediastolic;
    NSString *bpvalue = [NSString stringWithFormat:@"%d", systolic];
    bpvalue = [bpvalue stringByAppendingString:@" / "];
    bpvalue = [bpvalue stringByAppendingString:[NSString stringWithFormat:@"%d", diastolic]];
    self.currentBloodPressure.text = bpvalue;
    self.currentBloodPressureSystolic.text = [NSString stringWithFormat:@"%d", systolic];
    self.currentBloodPressureDiastolic.text = [NSString stringWithFormat:@"%d", diastolic];
    
    // Update the energy level
    self.currentEnergy.text = [self.energyLevel objectAtIndex:self.entry.energylevel];

    // Update the quality of sleep
    self.currentQualitySleep.text = [self.qualitySleep objectAtIndex:self.entry.qualityofsleep];

    // Update the fitness activity
    self.currentFitnessActivity.text = self.entry.fitnessactivity;
    
    // Update the nutrition
    self.currentNutrition.text = self.entry.nutrition;
    
    // Update the symptoms
    self.currentSymptomDescription.text = self.entry.symptomdescription;
    SymptomTypes *info = self.symptomtypes[self.entry.symptomtype];
    self.currentSymptomType.text = info.symptomdesc;
    
    // Update the view title
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.entry.dateentered];
    self.title = [NSDateFormatter localizedStringFromDate:date
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToEntries:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - Location Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    
    // Remove all previous annotations
    for (id annotation in self.currentMap.annotations) {
        [self.currentMap removeAnnotation:annotation];
    }
    
    // Create an invalid location
    CLLocationCoordinate2D errorLocation;
    errorLocation.longitude = 0;
    errorLocation.longitude = 0;
    
    // Adjust the map zoom
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(errorLocation, 475 * 1000, 475 * 1000);
    MKCoordinateRegion adjustedRegion = [self.currentMap regionThatFits:viewRegion];
    [self.currentMap setRegion:adjustedRegion animated:YES];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    // Update the map with the location for the entry
    Locations *location = self.locations[self.entry.location];
    
    NSLog(@"L: %f", location.latitude);
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

    
    [locationManager stopUpdatingLocation];
}


#pragma mark - Entries Support

/**
 * Loads the entries from the data file
 */
- (void)loadEntries {
    NSError *error;
    
    [self.entries removeAllObjects];
    
    // Prepare a fetch request for the entries entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entries" inManagedObjectContext:[self managedObjectContext]];
    
    // Set the entity to the entries entity
    [fetchRequest setEntity:entity];
    
    // Fetch the entries into an array
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Loop through the entries and store them in the locations class
    self.entries = [[NSMutableArray alloc] init];
    for (Entries *info in fetchedObjects) {
        [self.entries addObject:info];
    }
    
    // Inform the app that the entries list has changed
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"EntriesListHasChanged" object:self];
}
@end
