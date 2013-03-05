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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeUserName:(id)sender {
    [self.userName resignFirstResponder];
}

- (IBAction)changeUserWeight:(id)sender {
    [self.userWeight resignFirstResponder];
}

- (IBAction)changeUserHeight:(id)sender {
    [self.userHeight resignFirstResponder];
}

/**
 * Hides the keyboard
 */
- (IBAction)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}
@end
