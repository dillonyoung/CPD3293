//
//  GenderViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-05.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCAppDelegate.h"

@interface GenderViewController : UITableViewController <UITableViewDataSource>

// Create the property for the app delegate references
@property (strong, nonatomic) UserDetails *userdetails;

@end
