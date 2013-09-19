//
//  Game.h
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InputLayer.h"

@class Tank;
@interface GameScene : CCScene <InputLayerDelegate>
{
    CGSize _winSize;
    NSDictionary *_configuration;
    CCLayerGradient *_skyLayer;
    CGFloat _windSpeed;
    Tank *_tank;
    
    CCParallaxNode *_parallaxNode;
    CCNode *_gameNode;
    BOOL _followTank;
    CGFloat _landscapeWidth;
}

@end
