//
//  MapViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    CLLocationManager *locationManager;
}

// Synthesize the properties
@synthesize appDelegate = _appDelegate;
@synthesize preferences = _preferences;
@synthesize userdetails = _userdetails;
@synthesize symptomtypes = _symptomtypes;
@synthesize locations = _locations;
@synthesize entries = _entries;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
	// Do any additional setup after loading the view.
    
    // Initialize the location manager
    locationManager = [[CLLocationManager alloc] init];
    
    // Get the location
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    // Load the entries
    [self.appDelegate loadEntries];
    self.entries = self.appDelegate.entries;
    
    // Load the locations
    [self.appDelegate loadLocations];
    self.locations = self.appDelegate.locations;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    // Start tracking the user
    [locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    // Stop tracking the location
    [locationManager stopUpdatingLocation];
    
    // Save the data
    [self.appDelegate saveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Location Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Location error: %@", error);
    
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

- (void) locationManager:(CLLocationManager *)manager
      didUpdateLocations:(NSArray *)locations
{
    
    // Loop through the locations
    for (int count = 0; count < [locations count]; count++) {
        
        // Update the current location
        self.currentLocation = locations[count];
        
        // Remove all previous annotations
        for (id annotation in self.mapview.annotations) {
            [self.mapview removeAnnotation:annotation];
        }
        
        for (int ecount = 0; ecount < [self.entries count]; ecount++) {
            Entries *entry = self.entries[ecount];
            
            if (entry.location >= 0) {
                
                // Get the current location
                Locations *location = self.locations[entry.location];
            
                if (location.latitude == 0 && location.longitude == 0) {
                
                } else {
            
                    // Create a location
                    CLLocationCoordinate2D entryLocation;
                    entryLocation.latitude = location.latitude;
                    entryLocation.longitude = location.longitude;
            
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.dateentered];
                
                    // Create the map annotation
                    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                    point.coordinate = entryLocation;
                    point.title = [NSDateFormatter localizedStringFromDate:date
                                                             dateStyle:NSDateFormatterLongStyle
                                                             timeStyle:NSDateFormatterShortStyle];
                    
                    // Add the annotation to the map
                    [self.mapview addAnnotation:point];
                }
            }
        }
        
        // Build the map annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = self.currentLocation.coordinate;
        point.title = @"Current Location";
        
        // Add the new annotation
        //[self.mapview addAnnotation:point];
        
        // Adjust the map zoom
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(point.coordinate, 10000, 10000);
        MKCoordinateRegion adjustedRegion = [self.mapview regionThatFits:viewRegion];
        [self.mapview setRegion:adjustedRegion animated:YES];
    }
    
    // Stop the location tracking
    [locationManager stopUpdatingLocation];
}

@end
