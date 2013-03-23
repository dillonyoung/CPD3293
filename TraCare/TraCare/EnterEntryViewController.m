//
//  EnterEntryViewController.m
//  TraCare
//
//  Created by Dillon on 2013-03-04.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import "EnterEntryViewController.h"

@interface EnterEntryViewController ()

@end

@implementation EnterEntryViewController

@synthesize Group1Show = _Group1Show;

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
    _Group1Show = 1;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ShowCell:(id)sender {
    _Group1Show = 1;
    [self.tableView reloadData];
}

- (IBAction)HideCell:(id)sender {
    _Group1Show = 0;
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        if (_Group1Show == 0) {
            return  0;
        } else {
            return 1;
        }
    }
    else
    
        return 1;
    }

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_Group1Show == 0 && section == 1)
        return [[UIView alloc] initWithFrame:CGRectZero];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1 && _Group1Show == 0)
        return 1;
    return 32;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 1 && _Group1Show == 0)
        return 1;
    return 16;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1 && _Group1Show == 0)
        return [[UIView alloc] initWithFrame:CGRectZero];
    return nil;
}

@end
