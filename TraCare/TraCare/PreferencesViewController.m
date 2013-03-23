//
//  PreferencesViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-04.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

@synthesize appDelegate = _appDelegate;
@synthesize preferences = _preferences;
@synthesize userdetails = _userdetails;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.appDelegate = (TCAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.preferences = self.appDelegate.preferences;
    self.userdetails = self.appDelegate.userdetails;
}

- (void)viewWillAppear:(BOOL)animated {
    //TCAppDelegate *appDelegate = (TCAppDelegate *)[[UIApplication sharedApplication] delegate];

    [self UpdatePreferenceDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeUserName:(id)sender {
    [self.userName resignFirstResponder];
    self.userdetails.name = self.userName.text;
}

- (IBAction)changeUserWeight:(id)sender {
    [self.userWeight resignFirstResponder];
}

- (IBAction)changeUserHeight:(id)sender {
    [self.userHeight resignFirstResponder];
}

- (IBAction)changeTrackWeight:(id)sender {
    self.preferences.weight = self.trackWeight.on;
}

- (IBAction)changeTrackSleep:(id)sender {
    self.preferences.sleep = self.trackSleep.on;
}

- (IBAction)changeTrackBloodPressure:(id)sender {
    self.preferences.bloodpressure = self.trackBloodPressure.on;
}

- (IBAction)changeTrackEnergyLevel:(id)sender {
    self.preferences.energy = self.trackEnergyLevel.on;
}

- (IBAction)changeTrackQualityofSleep:(id)sender {
    self.preferences.qualityofsleep = self.trackQualityofSleep.on;
}

- (IBAction)changeTrackFitness:(id)sender {
    self.preferences.fitness = self.trackFitness.on;
}

- (IBAction)changeTrackNutrition:(id)sender {
    self.preferences.nutrition = self.trackNutrition.on;
}

/**
 * Hides the keyboard
 */
- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)UpdatePreferenceDisplay {
    
    // Update the tracking toggle states
    self.trackWeight.on = self.preferences.weight;
    self.trackSleep.on = self.preferences.sleep;
    self.trackBloodPressure.on = self.preferences.bloodpressure;
    self.trackEnergyLevel.on = self.preferences.energy;
    self.trackQualityofSleep.on = self.preferences.qualityofsleep;
    self.trackFitness.on = self.preferences.fitness;
    self.trackNutrition.on = self.preferences.nutrition;
    
    // Update the user details
    self.userName.text = self.userdetails.name;
}
@end
