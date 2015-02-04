//
//  Result.m
//  Lab01-Ski
//
//  Created by Bigras, Renaud on 2015-02-04.
//  Copyright (c) 2015 Legault, Mathieu. All rights reserved.
//

#import "Result.h"

@implementation Result

- (id)init
{
    self = [super init];
    if (self)
    {
        time = -1.0;
    }
    return self;
}

-(void) setTime: (NSTimeInterval) t
{
    time = t;
}

-(NSTimeInterval) getTime
{
    return time;
}

-(NSString*) getTimeAsString
{
    return @"";
}

@end
