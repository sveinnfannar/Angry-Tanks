//
//  Game.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Game.h"


@implementation Game

- (id)init
{
    self = [super init];
    if (self)
    {
        // Your initilization code goes here
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)delta
{
    // Update logic goes here
}

@end
