//
//  HeightViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-24.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "HeightViewController.h"

@interface HeightViewController ()

@end

@implementation HeightViewController

// Synthesize the properties
@synthesize feet = _feet;
@synthesize inches = _inches;
@synthesize meters = _meters;
@synthesize centimeters = _centimeters;

@synthesize picker = _picker;

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

    // Load the feet array with values
    self.feet = [[NSMutableArray alloc] init];
    for (int i = 1; i < 10; i++) {
        NSMutableString *entry = [NSMutableString stringWithFormat:@"%d ft", i];
        [self.feet addObject:entry];
    }
    
    // Load the inches array with values
    self.inches = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i++) {
        NSMutableString *entry = [NSMutableString stringWithFormat:@"%d in", i];
        [self.inches addObject:entry];
    }
    
    // Load the meters array with values
    self.meters = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        NSMutableString *entry = [NSMutableString stringWithFormat:@"%d m", i];
        [self.meters addObject:entry];
    }
    
    // Load the centimeters array with values
    self.centimeters = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100; i++) {
        NSMutableString *entry = [NSMutableString stringWithFormat:@"%d cm", i];
        [self.centimeters addObject:entry];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    // Check to see which default units mode is selected and update the display
    if (self.preferences.defaultunits == 1) {
        float inchhold = self.userdetails.height * 0.39370;
        int feet = (int)(inchhold / 12.0);
        int inches = (int)(inchhold - (feet * 12));
        feet = feet - 1;

        [self.picker selectRow:feet inComponent:0 animated:NO];
        [self.picker selectRow:inches inComponent:1 animated:NO];
    } else {
        int meters = (int)(self.userdetails.height / 100);
        int centimeters = (int)(self.userdetails.height - (meters * 100));

        [self.picker selectRow:meters inComponent:0 animated:NO];
        [self.picker selectRow:centimeters inComponent:1 animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    // Return the number of sections in the picker view
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    
    // Check to see which default units mode is selected and update the component count
    if (self.preferences.defaultunits == 1) {
        if (component == 0) {
            return [self.feet count];
        }
        return [self.inches count];
    } else {
        if (component == 0) {
            return [self.meters count];
        }
        return [self.centimeters count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    // Check to see which default units mode is selected and update the component display
    if (self.preferences.defaultunits == 1) {
        if (component == 0) {
            return [self.feet objectAtIndex:row];
        }
        return [self.inches objectAtIndex:row];
    } else {
        if (component == 0) {
            return [self.meters objectAtIndex:row];
        }
        return [self.centimeters objectAtIndex:row];
    }
}

#pragma mark PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    // Check to see which default units mode is selected and update the user's weight
    if (self.preferences.defaultunits == 1) {
        float inches = (([self.picker selectedRowInComponent:0] + 1) * 12);
        inches = inches + ([self.picker selectedRowInComponent:1]);
        float centimeters = inches / 0.39370;
        self.userdetails.height = centimeters;
    } else {
        float centimeters = ([self.picker selectedRowInComponent:0] * 100);
        centimeters = centimeters + ([self.picker selectedRowInComponent:1]);
        self.userdetails.height = centimeters;
    }
}

@end
