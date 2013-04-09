//
//  TabBarViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-22.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCAppDelegate.h"

@interface TabBarViewController : UITabBarController

// Create the property for the app delegate reference
@property (strong, nonatomic) TCAppDelegate *appDelegate;

@end
