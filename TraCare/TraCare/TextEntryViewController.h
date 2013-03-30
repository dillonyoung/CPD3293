//
//  TextEntryViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-29.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextEntryViewController : UIViewController

@property (strong, nonatomic) NSDictionary *entryData;

@property (strong, nonatomic) IBOutlet UITextView *currentTextEntry;
@end
