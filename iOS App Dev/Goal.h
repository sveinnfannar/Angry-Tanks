//
//  Goal.h
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/24/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Goal : CCPhysicsSprite {
    
}

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;

@end
