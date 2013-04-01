//
//  SummaryTypeViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-31.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "SummaryTypeViewController.h"

@interface SummaryTypeViewController ()

@end

@implementation SummaryTypeViewController

@synthesize selectedIndex = _selectedIndex;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Add the checkmark to the selected table index
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [cell setSelected:TRUE animated:TRUE];
    
    // Highlight the selected row in the table
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:0];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Remove the checkmark from the previous table index
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:path];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    [oldCell setSelected:FALSE animated:TRUE];
    
    // Add the checkmark to the current table index
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [cell setSelected:TRUE animated:TRUE];
    
    // Update the selected default unit with the current index
    self.selectedIndex = indexPath.row;
    
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
    [newData setObject:@"Summary" forKey:@"Field"];
    [newData setObject:[NSNumber numberWithInteger:self.selectedIndex] forKey:@"Value"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SummaryTypeHasChanged" object:self userInfo:newData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
