//
//  UserDetails.h
//  TraCare
//
//  Created by Dillon on 2013-03-22.
//  Copyright (c) 2013 Dillon Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserDetails : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t gender;
@property (nonatomic) float weight;
@property (nonatomic) float height;

@end
