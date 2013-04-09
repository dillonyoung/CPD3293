//
//  WeightViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-23.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "WeightViewController.h"

@interface WeightViewController ()

@end

@implementation WeightViewController

// Synthesize the properties
@synthesize pounds = _pounds;
@synthesize ounces = _ounces;
@synthesize kilograms = _kilograms;
@synthesize grams = _grams;

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
    // Load the pounds array with values
    self.pounds = [[NSMutableArray alloc] init];
    for (int i = 1; i < 400; i++) {
        NSMutableString *entry = [NSMutableString stringWithFormat:@"%d lbs", i];
        [self.pounds addObject:entry];
    }
    
    // Load the ounces array with values
    self.ounces = [[NSMutableArray alloc] init];
    for (int i = 0; i < 16; i++) {
        NSMutableString *entry = [NSMutableString stringWithFormat:@"%d oz", i];
        [self.ounces addObject:entry];
    }
    
    // Load the kilograms array with values
    self.kilograms = [[NSMutableArray alloc] init];
    for (int i = 1; i < 200; i++) {
        NSMutableString *entry = [NSMutableString stringWithFormat:@"%d kg", i];
        [self.kilograms addObject:entry];
    }
    
    // Load the grams array with values
    self.grams = [[NSMutableArray alloc] init];
    for (int i = 0; i < 1000; i++) {
        NSMutableString *entry = [NSMutableString stringWithFormat:@"%d g", i];
        [self.grams addObject:entry];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    // Check to see which default units mode is selected and update the display
    if (self.preferences.defaultunits == 1) {
        float ouncehold = self.userdetails.weight * 0.035274;
        int pounds = (int)(ouncehold / 16.0);
        int ounces = (int)(ouncehold - (pounds * 16));
        pounds = pounds - 1;
    
        [self.picker selectRow:pounds inComponent:0 animated:NO];
        [self.picker selectRow:ounces inComponent:1 animated:NO];
    } else {
        int kilograms = (int)(self.userdetails.weight / 1000);
        int grams = (int)(self.userdetails.weight - (kilograms * 1000));
        kilograms = kilograms - 1;
        
        [self.picker selectRow:kilograms inComponent:0 animated:NO];
        [self.picker selectRow:grams inComponent:1 animated:NO];
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
            return [self.pounds count];
        }
        return [self.ounces count];
    } else {
        if (component == 0) {
            return [self.kilograms count];
        }
        return [self.grams count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    // Check to see which default units mode is selected and update the component display
    if (self.preferences.defaultunits == 1) {
        if (component == 0) {
            return [self.pounds objectAtIndex:row];
        }
        return [self.ounces objectAtIndex:row];
    } else {
        if (component == 0) {
            return [self.kilograms objectAtIndex:row];
        }
        return [self.grams objectAtIndex:row];
    }
}

#pragma mark PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    // Check to see which default units mode is selected and update the user's weight
    if (self.preferences.defaultunits == 1) {
        float ounces = (([self.picker selectedRowInComponent:0] + 1) * 16);
        ounces = ounces + ([self.picker selectedRowInComponent:1]);
        float grams = ounces / 0.035274;
        self.userdetails.weight = grams;
    } else {
        float grams = (([self.picker selectedRowInComponent:0] + 1) * 1000);
        grams = grams + ([self.picker selectedRowInComponent:1]);
        self.userdetails.weight = grams;
    }
}

@end
