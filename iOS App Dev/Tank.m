//
//  Tank.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/19/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Tank.h"


@implementation Tank

- (id)initWithPosition:(CGPoint)position
{
    self = [super initWithFile:@"Tank.png"];
    if (self)
    {
        self.position = position;
    }
    return self;
}

- (void)jump
{
    CCJumpTo *jump = [CCJumpTo actionWithDuration:1.5f position:ccp(530, 215) height:100.0f jumps:1];
    CCRotateBy *rotate = [CCRotateBy actionWithDuration:1.5f angle:350];
    [self runAction:jump];
    [self runAction:rotate];
}

@end
