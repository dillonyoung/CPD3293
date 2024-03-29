//
//  TCAppDelegate.m
//  TraCare
//
//  Created by Dillon on 2013-03-04.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "TCAppDelegate.h"

#import "Preferences.h"

@implementation TCAppDelegate

// Synthesize the properties
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize preferences = _preferences;
@synthesize userdetails = _userdetails;
@synthesize symptomtypes = _symptomtypes;
@synthesize locations = _locations;
@synthesize entries = _entries;

@synthesize firstRun = _firstRun;

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Set the default state for first run variable
    self.firstRun = false;
    
    // Create the preferences entity if needed
    [self createPreferences];
    
    // Create the user details entity if needed
    [self createUserDetails];
    
    // Create the symptom types entity if needed
    [self createSymptomTypes];
    
    // Load the preferences entity data
    [self loadPreferences];
    
    // Load the user details entity data
    [self loadUserDetails];
    
    // Load the symptom types entity data
    [self loadSymptomTypes];
    
    // Load the locations entity data
    [self loadLocations];
    
    // Load the entries entity data
    [self loadEntries];
    

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Save the application data
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Save the application data
    [self saveData];
}


#pragma mark - Core Data Stack

- (NSManagedObjectContext *)managedObjectContext
{
    
    // Check to see if the managed object context is set and return it
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // Check to see if the persistent store is set
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        
        // Set the managed object context for the application
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    // Return the managed object context
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    
    // Check to see if the managed object model exists and return it
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    // Get the file URL
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TraCare" withExtension:@"momd"];
    
    // Set the managed object model based on the file URL
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Return the managed object model
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    // Check to see if the persistent store coordinator is set and return it
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Get the persistent store URL
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TraCare.sqlite"];
    
    NSError *error = nil;
    
    // Set the persistent store coordinator base on the store URL
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // Check to see if the persistent store is valid
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    // Return the persistent store coordinator
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    
    // Get the directory to store the data file
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Preference Support

- (void)createPreferences
{

    // Prepare a fetch request for the preferences entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName:@"Preferences"
                                    inManagedObjectContext:[self managedObjectContext]]];
    
    // Get the count of entries in the preference entity
    NSError *errorCount = nil;
    NSUInteger count = [[self managedObjectContext] countForFetchRequest:request
                                                                   error:&errorCount];
    
    // Check to see if the number of entities is not equal to 1
    if (count != 1) {
        
        // Remove all entries from preferences entity
        [self deleteAllObjectsWithEntityName:@"Preferences"
                                   inContext:[self managedObjectContext]];
    
        // Create a new preferences entity
        Preferences *pref = [NSEntityDescription insertNewObjectForEntityForName:@"Preferences"
                                                          inManagedObjectContext:[self managedObjectContext]];
        
        // Update the values of the preferences entity to the default values
        pref.weight = YES;
        pref.bloodpressure = YES;
        pref.energy = YES;
        pref.fitness = YES;
        pref.qualityofsleep = YES;
        pref.nutrition = YES;
        pref.sleep = YES;
        pref.symptom = YES;
        pref.location = YES;
        pref.defaultunits = 2;

        NSError *error;
    
        // Attempt to save the preferences
        if( ! [[self managedObjectContext] save:&error] ){
            NSLog(@"Cannot save data: %@", [error localizedDescription]);
        }
        
        self.firstRun = true;
    }
}

- (void)loadPreferences
{
    
    NSError *error;
    
    // Prepare a fetch request for the preference entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Preferences"
                                              inManagedObjectContext:[self managedObjectContext]];
    
    // Set the entity to the preferences entity
    [fetchRequest setEntity:entity];
    
    // Fetch the entries into an array
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest
                                                                         error:&error];
    
    // Loop through the entries and store them in the preferences class
    for (Preferences *info in fetchedObjects) {
        self.preferences = info;
    }
}


#pragma mark - User Detail Support

- (void)createUserDetails
{
    
    // Prepare a fetch request for the user details entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName:@"UserDetails"
                                    inManagedObjectContext:[self managedObjectContext]]];
    
    // Get the count of entries in the user details entity
    NSError *errorCount = nil;
    NSUInteger count = [[self managedObjectContext] countForFetchRequest:request
                                                                   error:&errorCount];
    
    // Check to see if the number of entities is not equal to 1
    if (count != 1) {
        
        // Remove all entries from user details entity
        [self deleteAllObjectsWithEntityName:@"UserDetails"
                                   inContext:[self managedObjectContext]];
        
        // Create a new user details entity
        UserDetails *userdetails = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetails"
                                                                 inManagedObjectContext:[self managedObjectContext]];
        
        // Update the values of the user details entity to the default values
        userdetails.name = @"User";
        userdetails.gender = 1;
        userdetails.weight = 50000.0;
        userdetails.height = 153;
        
        NSError *error;
        
        // Attempt to save the preferences
        if( ! [[self managedObjectContext] save:&error] ){
            NSLog(@"Cannot save data: %@", [error localizedDescription]);
        }
    }
}

- (void)loadUserDetails
{
    
    NSError *error;
    
    // Prepare a fetch request for the user details entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserDetails"
                                              inManagedObjectContext:[self managedObjectContext]];
    
    // Set the entity to the user details entity
    [fetchRequest setEntity:entity];
    
    // Fetch the entries into an array
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest
                                                                         error:&error];
    
    // Loop through the entries and store them in the preferences class
    for (UserDetails *info in fetchedObjects) {
        self.userdetails = info;
    }
}


#pragma mark - Symptom Type Support

- (void)createSymptomTypes
{
    
    // Prepare a fetch request for the symptom types entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName:@"SymptomTypes"
                                    inManagedObjectContext:[self managedObjectContext]]];
    
    // Initialize the symptom types array
    NSArray *stypes = [[NSArray alloc] initWithObjects:@"Not Specified", @"Other", @"Abdominal Pain", @"Chest Pain", @"Constipation", @"Cought", @"Diarrea", @"Dizziness", @"Eye Discomfort", @"Foot Pain", @"Headaches", @"Hip Pain", @"Knee Pain", @"Low Back Pain", @"Nasal Congestion", @"Nausea", @"Neck Pain", @"Numbness", @"Shortness of Breath", @"Shoulder Pain", @"Sore Throat", @"Vision Problems", @"Wheezing", nil];
    
        
    for (int count = 0; count < [stypes count]; count++) {

        [request setPredicate:[NSPredicate predicateWithFormat:@"symptomdesc == %@", stypes[count]]];
            
        NSError *error;
            
        if ([[self managedObjectContext] countForFetchRequest:request
                                                        error:&error]) {
                
        } else {
             
            // Create a new symptom types entity
            SymptomTypes *newsymptom = [NSEntityDescription insertNewObjectForEntityForName:@"SymptomTypes"
                                                                     inManagedObjectContext:[self managedObjectContext]];
                
            // Update the values of the symptom types entity to the default values
            newsymptom.id = 1;
            newsymptom.symptomdesc = stypes[count];
                
            // Attempt to save the preferences
            if( ! [[self managedObjectContext] save:&error] ){
                NSLog(@"Cannot save data: %@", [error localizedDescription]);
            }
        }
    }
}

- (void)loadSymptomTypes
{
    
    NSError *error;
    
    [self.symptomtypes removeAllObjects];
    
    // Prepare a fetch request for the symptom types entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SymptomTypes"
                                              inManagedObjectContext:[self managedObjectContext]];
    
    // Set the entity to the symptom types entity
    [fetchRequest setEntity:entity];
    
    // Fetch the entries into an array
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest
                                                                         error:&error];
    
    // Loop through the entries and store them in the symptom types class
    self.symptomtypes = [[NSMutableArray alloc] init];
    for (SymptomTypes *info in fetchedObjects) {
        [self.symptomtypes addObject:info];
    }
}


#pragma mark - Location Support

- (void)loadLocations
{
    
    NSError *error;
    
    [self.locations removeAllObjects];
    
    // Prepare a fetch request for the locations entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Locations"
                                              inManagedObjectContext:[self managedObjectContext]];
    
    // Set the entity to the locations entity
    [fetchRequest setEntity:entity];
    
    // Fetch the entries into an array
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest
                                                                         error:&error];
    
    // Loop through the entries and store them in the locations class
    self.locations = [[NSMutableArray alloc] init];
    for (Locations *info in fetchedObjects) {
        [self.locations addObject:info];
    }
}


#pragma mark - Entries Support

- (void)loadEntries
{
    
    NSError *error;
    
    [self.entries removeAllObjects];
    
    // Prepare a fetch request for the entries entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entries"
                                              inManagedObjectContext:[self managedObjectContext]];
    
    // Set the entity to the entries entity
    [fetchRequest setEntity:entity];
    
    // Fetch the entries into an array
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest
                                                                         error:&error];
    
    // Loop through the entries and store them in the locations class
    self.entries = [[NSMutableArray alloc] init];
    for (Entries *info in fetchedObjects) {
        [self.entries addObject:info];
    }
}


#pragma mark - Shared Methods

- (void)saveData
{
    
    NSError *error = nil;

    // Check to see if the entity has changed and attempt to save the changes
    if ([self managedObjectContext] != nil) {
        if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

- (void)deleteAllObjectsWithEntityName:(NSString *)entityName
                             inContext:(NSManagedObjectContext *)context
{
    
    // Prepare a fetch request for the select entity
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.includesSubentities = NO;
    
    NSError *error;
    
    // Load the list of entries into an array
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    // Loop through the entries and delete them
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}
@end
