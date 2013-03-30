//
//  Preferences.h
//  TraCare
//
//  Created by Dillon on 2013-03-24.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Preferences : NSManagedObject

@property (nonatomic) BOOL bloodpressure;
@property (nonatomic) int16_t defaultunits;
@property (nonatomic) BOOL energy;
@property (nonatomic) BOOL fitness;
@property (nonatomic) BOOL nutrition;
@property (nonatomic) BOOL qualityofsleep;
@property (nonatomic) BOOL sleep;
@property (nonatomic) BOOL weight;
@property (nonatomic) BOOL symptom;
@property (nonatomic) BOOL location;

@end
