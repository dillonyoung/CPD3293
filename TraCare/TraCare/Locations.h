//
//  Locations.h
//  TraCare
//
//  Created by Dillon on 2013-03-29.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Locations : NSManagedObject

@property (nonatomic) int16_t index;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
