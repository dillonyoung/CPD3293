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

static NSString* const GenderViewSegueIdentifier = @"Gender Select View";
static NSString* const WeightViewSegueIdentifier = @"Weight Select View";
static NSString* const DefaultUnitsViewSegueIdentifier = @"Default Units Select View";

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
    
    // Check to see if the username entered is blank
    if ([self.userName.text isEqual: @""]) {
        self.userName.text = self.userdetails.name;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blank Name" message:@"You must enter a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        self.userdetails.name = self.userName.text;
    }
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

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:GenderViewSegueIdentifier]) {
        GenderViewController* controller = segue.destinationViewController;
        controller.userdetails = self.userdetails;
    } else if ([segue.identifier isEqual:WeightViewSegueIdentifier]) {
        WeightViewController* controller = segue.destinationViewController;
        controller.preferences = self.preferences;
        controller.userdetails = self.userdetails;
    } else if ([segue.identifier isEqual:DefaultUnitsViewSegueIdentifier]) {
        DefaultUnitsViewController* controller = segue.destinationViewController;
        controller.preferences = self.preferences;
    }
}
@end
