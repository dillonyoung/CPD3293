//
//  MapViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TCAppDelegate.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate>

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

@property (strong, nonatomic) IBOutlet MKMapView *mapview;

// Create the property for the current location
@property (strong, nonatomic) CLLocation *currentLocation;

@end
