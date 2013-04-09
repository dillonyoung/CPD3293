//
//  Entries.h
//  TraCare
//
//  Created by Dillon on 2013-03-30.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entries : NSManagedObject

// Define the model properties
@property (nonatomic) int16_t bloodpressurediastolic;
@property (nonatomic) int16_t bloodpressuresystolic;
@property (nonatomic) NSTimeInterval dateentered;
@property (nonatomic) int16_t energylevel;
@property (nonatomic, retain) NSString * fitnessactivity;
@property (nonatomic) float hoursofsleep;
@property (nonatomic) int16_t location;
@property (nonatomic, retain) NSString * nutrition;
@property (nonatomic) int16_t qualityofsleep;
@property (nonatomic, retain) NSString * symptomdescription;
@property (nonatomic) int16_t symptomtype;
@property (nonatomic) float weight;

@end
