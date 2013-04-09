//
//  DateSelectViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-31.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "DateSelectViewController.h"

@interface DateSelectViewController ()

@end

@implementation DateSelectViewController

// Synthesize the properties
@synthesize entryData = _entryData;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

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

- (void)viewWillAppear:(BOOL)animated
{
    
    // Check to see which date field is to be updated
    if ([[self.entryData valueForKey:@"Field"] isEqual:@"Start"]) {
        
        // Update the start date
        [self.datePicker setMaximumDate:self.endDate];
        [self.datePicker setDate:self.startDate];
    } else if ([[self.entryData valueForKey:@"Field"] isEqual:@"End"]) {
        
        // Update the end date
        [self.datePicker setMinimumDate:self.startDate];
        [self.datePicker setDate:self.endDate];
    }
}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateChanged:(id)sender
{
    
    // Get the date from the picker view
    NSDate *date = [self.datePicker date];
    
    // Create and send a notification that the weight has been changed
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    [newData setObject:[self.entryData valueForKey:@"Field"] forKey:@"Field"];
    [newData setObject:date forKey:@"Date"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DateHasChanged" object:self userInfo:newData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
