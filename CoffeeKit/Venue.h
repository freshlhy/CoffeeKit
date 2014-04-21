//
//  Venue.h
//  CoffeeKit
//
//  Created by freshlhy on 14-4-17.
//  Copyright (c) 2014年 freshlhy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;
@class Stats;

@interface Venue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Location *location;
@property (strong, nonatomic) Stats *stats;


@end
