//
//  Preferences.h
//  TraCare
//
//  Created by Dillon on 2013-03-22.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Preferences : NSManagedObject

@property (nonatomic) BOOL weight;
@property (nonatomic) BOOL qualityofsleep;
@property (nonatomic) BOOL bloodpressure;
@property (nonatomic) BOOL energy;
@property (nonatomic) BOOL sleep;
@property (nonatomic) BOOL fitness;
@property (nonatomic) BOOL nutrition;

@end
