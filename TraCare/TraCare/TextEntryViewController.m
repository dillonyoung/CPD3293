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

- (void)viewWillAppear:(BOOL)animated {
    
    // Update the view with the data passed from the parent view
    self.currentTextEntry.text = [self.entryData valueForKey:@"Text"];
    self.title = [self.entryData valueForKey:@"Field"];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.currentTextEntry becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    [newData setObject:[self.entryData valueForKey:@"Field"] forKey:@"Field"];
    [newData setObject:self.currentTextEntry.text forKey:@"Text"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextEntryHasChanged" object:self userInfo:newData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) keyboardWillAppear:(NSNotification*)notification {
    [self resizeTextViewForKeyboard:notification shown:YES];
}

- (void) keyboardWillDisappear:(NSNotification*)notification {
    [self resizeTextViewForKeyboard:notification shown:NO];
}

- (void)resizeTextViewForKeyboard:(NSNotification*)notification shown:(BOOL)shown {
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.currentTextEntry.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    keyboardFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
    
    if (shown) {
        newFrame.size.height -= keyboardFrame.size.height;
    } else {
        newFrame.size.height += keyboardFrame.size.height;
    }
    
    self.currentTextEntry.frame = newFrame;
    
    [UIView commitAnimations];
}

@end
