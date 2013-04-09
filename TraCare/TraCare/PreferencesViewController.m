//
//  PreferencesViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-04.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "PreferencesViewController.h"

#import "GenderViewController.h"
#import "WeightViewController.h"
#import "DefaultUnitsViewController.h"
#import "HeightViewController.h"

// Declare the segue name constants
static NSString* const GenderViewSegueIdentifier = @"Gender Select View";
static NSString* const WeightViewSegueIdentifier = @"Weight Select View";
static NSString* const DefaultUnitsViewSegueIdentifier = @"Default Units Select View";
static NSString* const HeightViewSegueIdentifier = @"Height Select View";

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

// Synthesize the properties
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
    
    // Get the app delegate and user details and preferences
    self.appDelegate = (TCAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.preferences = self.appDelegate.preferences;
    self.userdetails = self.appDelegate.userdetails;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {

    // Update the preference display
    [self UpdatePreferenceDisplay];
}

- (void)viewWillDisappear:(BOOL)animated
{

    // Save the data
    [self.appDelegate saveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeUserName:(id)sender
{
    
    // Stop the name input field from being an input responder
    [self.userName resignFirstResponder];
    
    // Check to see if the username entered is blank
    if ([self.userName.text isEqual: @""]) {
        self.userName.text = self.userdetails.name;
        
        // Inform the user the name can't be blank
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blank Name"
                                                        message:@"You must enter a name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        
        // Update the user name
        self.userdetails.name = self.userName.text;
    }
}

- (IBAction)changeTrackWeight:(id)sender
{
    
    // Update the weight tracking preference
    self.preferences.weight = self.trackWeight.on;
}

- (IBAction)changeTrackSleep:(id)sender
{
    
    // Update the sleep tracking preference
    self.preferences.sleep = self.trackSleep.on;
}

- (IBAction)changeTrackBloodPressure:(id)sender
{
    
    // Update the blood pressure tracking preference
    self.preferences.bloodpressure = self.trackBloodPressure.on;
}

- (IBAction)changeTrackEnergyLevel:(id)sender
{
    
    // Update the energy level tracking preference
    self.preferences.energy = self.trackEnergyLevel.on;
}

- (IBAction)changeTrackQualityofSleep:(id)sender
{
    
    // Update the quality of sleep tracking preference
    self.preferences.qualityofsleep = self.trackQualityofSleep.on;
}

- (IBAction)changeTrackFitness:(id)sender
{
    
    // Update the fitness activity tracking preference
    self.preferences.fitness = self.trackFitness.on;
}

- (IBAction)changeTrackNutrition:(id)sender
{
    
    // Update the nutrition tracking preference
    self.preferences.nutrition = self.trackNutrition.on;
}

- (IBAction)changeTrackSymptom:(id)sender {
    
    // Update the symptom tracking preference
    self.preferences.symptom = self.trackSymptom.on;
}

- (IBAction)changeTrackLocation:(id)sender
{
    
    // Update the location tracking preference
    self.preferences.location = self.trackLocation.on;
}

- (IBAction)hideKeyboard:(id)sender
{
    
    // Hide the keyboard
    [self.view endEditing:YES];
}

- (void)UpdatePreferenceDisplay
{
    
    // Update the tracking toggle states
    self.trackWeight.on = self.preferences.weight;
    self.trackSleep.on = self.preferences.sleep;
    self.trackBloodPressure.on = self.preferences.bloodpressure;
    self.trackEnergyLevel.on = self.preferences.energy;
    self.trackQualityofSleep.on = self.preferences.qualityofsleep;
    self.trackFitness.on = self.preferences.fitness;
    self.trackNutrition.on = self.preferences.nutrition;
    self.trackSymptom.on = self.preferences.symptom;
    self.trackLocation.on = self.preferences.location;
    
    // Update the default units
    if (self.preferences.defaultunits == 1) {
        self.defaultUnits.text = @"Imperial";
    } else {
        self.defaultUnits.text = @"Metric";
    }
    
    // Update the user details
    self.userName.text = self.userdetails.name;
    
    // Update the user's gender
    if (self.userdetails.gender == 1) {
        self.userGender.text = @"Male";
    } else {
        self.userGender.text = @"Female";
    }

    // Update the user's weight
    if (self.preferences.defaultunits == 1) {
        float ouncehold = self.userdetails.weight * 0.035274;
        int pounds = (int)(ouncehold / 16.0);
        int ounces = (int)(ouncehold - (pounds * 16));
        NSString *value = [NSString stringWithFormat:@"%d", pounds];
        value = [value stringByAppendingString:@" lbs "];
        value = [value stringByAppendingString:[NSString stringWithFormat:@"%d", ounces]];
        value = [value stringByAppendingString:@" oz"];
        self.userWeight.text = value;
    } else {
        int kilograms = (int)(self.userdetails.weight / 1000);
        int grams = (int)(self.userdetails.weight - (kilograms * 1000));
        NSString *value = [NSString stringWithFormat:@"%d", kilograms];
        value = [value stringByAppendingString:@" kg "];
        value = [value stringByAppendingString:[NSString stringWithFormat:@"%d", grams]];
        value = [value stringByAppendingString:@" g"];
        self.userWeight.text = value;
    }
    
    // Update the user's height
    if (self.preferences.defaultunits == 1) {
        float inchhold = self.userdetails.height * 0.39370;
        int feet = (int)(inchhold / 12.0);
        int inches = (int)(inchhold - (feet * 12));
        NSString *value = [NSString stringWithFormat:@"%d", feet];
        value = [value stringByAppendingString:@" ft "];
        value = [value stringByAppendingString:[NSString stringWithFormat:@"%d", inches]];
        value = [value stringByAppendingString:@" in"];
        self.userHeight.text = value;
    } else {
        int meters = (int)(self.userdetails.height / 100);
        int centimeters = (int)(self.userdetails.height - (meters * 100));
        NSString *value = [NSString stringWithFormat:@"%d", meters];
        value = [value stringByAppendingString:@" m "];
        value = [value stringByAppendingString:[NSString stringWithFormat:@"%d", centimeters]];
        value = [value stringByAppendingString:@" cm"];
        self.userHeight.text = value;
    }

}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    
    // Check to see if the destination view is the gender select view
    if ([segue.identifier isEqualToString:GenderViewSegueIdentifier]) {
        GenderViewController* controller = segue.destinationViewController;
        controller.userdetails = self.userdetails;
        
    // Check to see if the destination view is the weight select view
    } else if ([segue.identifier isEqual:WeightViewSegueIdentifier]) {
        WeightViewController* controller = segue.destinationViewController;
        controller.preferences = self.preferences;
        controller.userdetails = self.userdetails;
        
    // Check to see if the destination view is the default unit select view
    } else if ([segue.identifier isEqual:DefaultUnitsViewSegueIdentifier]) {
        DefaultUnitsViewController* controller = segue.destinationViewController;
        controller.preferences = self.preferences;
        
    // Check to see if the destination view is the dheight select view
    } else if ([segue.identifier isEqual:HeightViewSegueIdentifier]) {
        HeightViewController* controller = segue.destinationViewController;
        controller.preferences = self.preferences;
        controller.userdetails = self.userdetails;
    }
}
@end
