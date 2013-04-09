//
//  TabBarViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-22.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

// Synthesize the properties
@synthesize appDelegate = _appDelegate;

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
    
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    
    // Check to see if the app is being run for the first time and set the tab to the preferences tab
    if (self.appDelegate.firstRun) {
        
        // Change the tab to the preferences tab
        [self.tabBarController setSelectedIndex:3];
        self.tabBarController.selectedIndex = 3;

        // Create an alert to inform the user to update the preferences
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"First Run"
                                                          message:@"Thank you for using this application. Please configure your details in the preferences tab."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
