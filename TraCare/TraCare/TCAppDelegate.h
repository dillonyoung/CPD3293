//
//  TCAppDelegate.h
//  TraCare
//
//  Created by Dillon on 2013-03-04.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Preferences.h"
#import "UserDetails.h"
#import "SymptomTypes.h"
#import "Locations.h"
#import "Entries.h"

@interface TCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Create the properties for storing the application data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Create the properties for the application data
@property (strong, nonatomic) Preferences *preferences;
@property (strong, nonatomic) UserDetails *userdetails;
@property (strong, nonatomic) NSMutableArray *symptomtypes;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *entries;

// Create the property for the first run
@property (assign, nonatomic) BOOL firstRun;

// Create the methods
- (NSURL *)applicationDocumentsDirectory;

- (void)loadSymptomTypes;
- (void)loadLocations;
- (void)loadEntries;
- (void)saveData;

@end
