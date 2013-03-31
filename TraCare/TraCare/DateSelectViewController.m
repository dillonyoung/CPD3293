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

@synthesize entryData = _entryData;
@synthesize date = _date;

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
    
    if ([[self.entryData valueForKey:@"Field"] isEqual:@"Start"]) {
        [self.datePicker setDate:self.date];
    } else if ([[self.entryData valueForKey:@"Field"] isEqual:@"End"]) {
        [self.datePicker setDate:self.date];
    }
}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateChanged:(id)sender {
    
    self.date = [self.datePicker date];
    NSLog(@"D: %@", self.date);
    
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    [newData setObject:[self.entryData valueForKey:@"Field"] forKey:@"Field"];
    [newData setObject:self.date forKey:@"Date"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DateHasChanged" object:self userInfo:newData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
