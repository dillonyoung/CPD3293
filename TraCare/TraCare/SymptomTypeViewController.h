//
//  SymptomTypeViewController.h
//  TraCare
//
//  Created by Dillon on 2013-03-29.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SymptomTypes.h"

@interface SymptomTypeViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *symptomTypes;
@property (assign, nonatomic) NSInteger symptomIndex;

// Create the outlet for the picker
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end
