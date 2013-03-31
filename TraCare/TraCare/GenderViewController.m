//
//  GenderViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-05.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "GenderViewController.h"

@interface GenderViewController ()

@end

@implementation GenderViewController

@synthesize userdetails = _userdetails;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)viewDidAppear:(BOOL)animated {

    // Add the checkmark to the selected table index
    NSIndexPath *path = [NSIndexPath indexPathForRow:(self.userdetails.gender - 1) inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [cell setSelected:TRUE animated:TRUE];

    // Highlight the selected row in the table
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Remove the checkmark from the previous table index
    NSIndexPath *path = [NSIndexPath indexPathForRow:(self.userdetails.gender - 1) inSection:0];
    UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:path];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    [oldCell setSelected:FALSE animated:TRUE];
    
    // Add the checkmark to the current table index
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [cell setSelected:TRUE animated:TRUE];
    
    // Update the selected gender with the current index
    self.userdetails.gender = (indexPath.row + 1);
}

@end
