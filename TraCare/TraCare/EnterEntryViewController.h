//
//  EnterEntryViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-04.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterEntryViewController : UITableViewController

- (IBAction)ShowCell:(id)sender;
- (IBAction)HideCell:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *Table;
@property (assign, nonatomic) NSUInteger Group1Show;
@end
