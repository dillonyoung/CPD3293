//
//  SymptomTypes.h
//  TraCare
//
//  Created by Dillon on 2013-03-29.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SymptomTypes : NSManagedObject

// Define the model properties
@property (nonatomic) int16_t id;
@property (nonatomic, retain) NSString * symptomdesc;

@end
