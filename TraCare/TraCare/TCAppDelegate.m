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

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize preferences = _preferences;

@synthesize userdetails = _userdetails;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Create the preferences entity if needed
    [self createPreferences];
    
    // Create the user details entity if needed
    [self createUserDetails];
    
    // Load the preferences entity data
    [self loadPreferences];
    
    // Load the user details entity data
    [self loadUserDetails];
    
    // Return YES
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

/**
 * Get the managed object conect for the application
 */
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

/**
 * Returns the managed object model for the application
 */
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

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
/**
 * Returns the persistent store coordinator for the application
 */
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

/**
 * Get the document directory for the application
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Preference Support

/**
 * Creates the preferences entry in the data file if needed
 */
- (void)createPreferences {

    // Prepare a fetch request for the preferences entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"Preferences" inManagedObjectContext: [self managedObjectContext]]];
    
    // Get the count of entries in the preference entity
    NSError *errorCount = nil;
    NSUInteger count = [[self managedObjectContext] countForFetchRequest: request error: &errorCount];
    
    // Check to see if the number of entities is not equal to 1
    if (count != 1) {
        
        // Remove all entries from preferences entity
        [self deleteAllObjectsWithEntityName:@"Preferences" inContext:[self managedObjectContext]];
    
        // Create a new preferences entity
        Preferences *pref = [NSEntityDescription insertNewObjectForEntityForName:@"Preferences" inManagedObjectContext:[self managedObjectContext]];
        
        // Update the values of the preferences entity to the default values
        pref.weight = YES;
        pref.bloodpressure = YES;
        pref.energy = YES;
        pref.fitness = YES;
        pref.qualityofsleep = YES;
        pref.nutrition = YES;
        pref.sleep = YES;
        pref.defaultunits = 2;

        NSError *error;
    
        // Attempt to save the preferences
        if( ! [[self managedObjectContext] save:&error] ){
            NSLog(@"Cannot save data: %@", [error localizedDescription]);
        }
    }
}

/**
 * Loads the preferences from the data file
 */
- (void)loadPreferences {
    NSError *error;
    
    // Prepare a fetch request for the preference entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Preferences" inManagedObjectContext:[self managedObjectContext]];
    
    // Set the entity to the preferences entity
    [fetchRequest setEntity:entity];
    
    // Fetch the entries into an array
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Loop through the entries and store them in the preferences class
    for (Preferences *info in fetchedObjects) {
        self.preferences = info;
    }
}


#pragma mark - User Detail Support

/**
 * Creates the user detail entry in the data file if needed
 */
- (void)createUserDetails {
    
    // Prepare a fetch request for the user details entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity: [NSEntityDescription entityForName: @"UserDetails" inManagedObjectContext: [self managedObjectContext]]];
    
    // Get the count of entries in the user details entity
    NSError *errorCount = nil;
    NSUInteger count = [[self managedObjectContext] countForFetchRequest: request error: &errorCount];
    
    // Check to see if the number of entities is not equal to 1
    if (count != 1) {
        
        // Remove all entries from user details entity
        [self deleteAllObjectsWithEntityName:@"UserDetails" inContext:[self managedObjectContext]];
        
        // Create a new user details entity
        UserDetails *userdetails = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetails" inManagedObjectContext:[self managedObjectContext]];
        
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

/**
 * Loads the user details from the data file
 */
- (void)loadUserDetails {
    NSError *error;
    
    // Prepare a fetch request for the user details entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserDetails" inManagedObjectContext:[self managedObjectContext]];
    
    // Set the entity to the user details entity
    [fetchRequest setEntity:entity];
    
    // Fetch the entries into an array
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Loop through the entries and store them in the preferences class
    for (UserDetails *info in fetchedObjects) {
        self.userdetails = info;
    }
}


#pragma mark - Shared Methods

/**
 * Save the data to the data file
 */
- (void)saveData
{
    NSError *error = nil;
    
    // Check to see if the entity has changed and attempt to save the changes
    if ([self managedObjectContext] != nil) {
        if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    NSLog(@"Saving");
}

/**
 * Delete all of the entries for a given an entity name
 */
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
        NSLog(@"Deleted %@", entityName);
    }
}
@end
