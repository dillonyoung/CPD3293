//
//  Entries.h
//  TraCare
//
//  Created by Dillon on 2013-03-29.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entries : NSManagedObject

@property (nonatomic) float weight;
@property (nonatomic) float hoursofsleep;
@property (nonatomic) int16_t bloodpressuresystolic;
@property (nonatomic) int16_t bloodpressurediastolic;
@property (nonatomic) int16_t everylevel;
@property (nonatomic) int16_t qualityofsleep;
@property (nonatomic, retain) NSString * fitnessactivity;
@property (nonatomic, retain) NSString * nutrition;
@property (nonatomic) int16_t symptomtype;
@property (nonatomic, retain) NSString * symptomdescription;
@property (nonatomic) int16_t location;
@property (nonatomic) NSTimeInterval dateentered;

@end
