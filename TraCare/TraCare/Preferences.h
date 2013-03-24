//
//  Preferences.h
//  TraCare
//
//  Created by Dillon on 2013-03-23.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Preferences : NSManagedObject

@property (nonatomic) BOOL bloodpressure;
@property (nonatomic) BOOL energy;
@property (nonatomic) BOOL fitness;
@property (nonatomic) BOOL nutrition;
@property (nonatomic) BOOL qualityofsleep;
@property (nonatomic) BOOL sleep;
@property (nonatomic) BOOL weight;
@property (nonatomic) int16_t defaultunits;

@end
