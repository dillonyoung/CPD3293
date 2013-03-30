//
//  SymptomTypeViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-29.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "SymptomTypeViewController.h"

@interface SymptomTypeViewController ()

@end

@implementation SymptomTypeViewController

@synthesize symptomTypes = _symptomTypes;
@synthesize symptomIndex = _symptomIndex;

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

- (void)viewWillAppear:(BOOL)animated {
    [self.picker selectRow:self.symptomIndex inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.symptomTypes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    // Get the data for the row
    SymptomTypes *info = self.symptomTypes[row];
    return info.symptomdesc;
}

#pragma mark PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    [newData setObject:[NSNumber numberWithInteger:row] forKey:@"Symptom"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SymptomTypeHasChanged" object:self userInfo:newData];
}


@end
