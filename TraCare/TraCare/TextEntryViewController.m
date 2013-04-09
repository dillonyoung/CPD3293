//
//  TextEntryViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-29.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "TextEntryViewController.h"

@interface TextEntryViewController ()

@end

@implementation TextEntryViewController

// Synthesize the properties
@synthesize entryData = _entryData;

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
    
    // Update the view with the data passed from the parent view
    self.currentTextEntry.text = [self.entryData valueForKey:@"Text"];
    self.title = [self.entryData valueForKey:@"Field"];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    // Register the for the notification that the keyboard will appear
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register for the notification that the keyboard will disappear
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Set the text view to be the active view element
    [self.currentTextEntry becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    // Create and send a notification that the text content has changed
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    [newData setObject:[self.entryData valueForKey:@"Field"] forKey:@"Field"];
    [newData setObject:self.currentTextEntry.text forKey:@"Text"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextEntryHasChanged"
                                                        object:self
                                                      userInfo:newData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) keyboardWillAppear:(NSNotification*)notification
{
    
    // Show the keyboard and resize the text view accordingly
    [self resizeTextViewForKeyboard:notification shown:YES];
}

- (void) keyboardWillDisappear:(NSNotification*)notification
{
    
    // Hide the keyboard and resize the text view accordingly
    [self resizeTextViewForKeyboard:notification shown:NO];
}

- (void)resizeTextViewForKeyboard:(NSNotification*)notification shown:(BOOL)shown
{
    
    // Get the notification details and declare variables
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    // Get the values for the keyboard
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    // Set the view values based on the keyboard values
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    // Resize the frame of the text view and keyboard
    CGRect newFrame = self.currentTextEntry.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    keyboardFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
    
    // Modify the frame depending on whether the keyboard is visible or not
    if (shown) {
        newFrame.size.height -= keyboardFrame.size.height;
    } else {
        newFrame.size.height += keyboardFrame.size.height;
    }
    
    // Update the frame
    self.currentTextEntry.frame = newFrame;
    
    // Update the display
    [UIView commitAnimations];
}

@end
