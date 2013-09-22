//
//  Tank.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/19/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Tank.h"


@implementation Tank

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
{
    self = [super initWithFile:@"Tank.png"];
    if (self)
    {
        _space = space;
        
        if (_space != nil)
        {
            CGSize size = self.textureRect.size;
            cpFloat mass = size.width * size.height;
            cpFloat moment = cpMomentForBox(mass, size.width, size.height);
            
            ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:moment];
            body.pos = position;
            ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
            
            // Add to space
            [_space addBody:body];
            [_space addShape:shape];
            
            // Add to pysics sprite
            self.chipmunkBody = body;
        }
    }
    return self;
}

- (void)jumpWithPower:(CGFloat)power vector:(cpVect)vector
{
    cpVect impulseVector = cpvmult(vector, self.chipmunkBody.mass * power);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}

@end
