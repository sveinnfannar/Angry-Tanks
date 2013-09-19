//
//  Game.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "GameScene.h"
#import "Tank.h"
#import "InputLayer.h"

@implementation GameScene

#pragma mark - Initilization

- (id)init
{
    self = [super init];
    if (self)
    {
        srandom(time(NULL));
        
        _configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
        
        _winSize = [CCDirector sharedDirector].winSize;
               
        [self generateRandomWind];
        [self setupGraphicsLandscape];
        
        // Add a tank
        NSString *tankPositionString = _configuration[@"tankPosition"];
        _tank = [[Tank alloc] initWithPosition:CGPointFromString(tankPositionString)];
        [self addChild:_tank];
        
        // Create a input layer
        InputLayer *inputLayer = [[InputLayer alloc] init];
        inputLayer.delegate = self;
        [self addChild:inputLayer];
        
        // Your initilization code goes here
        [self scheduleUpdate];
    }
    return self;
}

- (void)setupGraphicsLandscape
{
    // Sky
    _skyLayer = [CCLayerGradient layerWithColor:ccc4(89, 67, 245, 255) fadingTo:ccc4(67, 219, 245, 255)];
    [self addChild:_skyLayer];
    
    for (NSUInteger i = 0; i < 4; ++i)
    {
        CCSprite *cloud = [CCSprite spriteWithFile:@"Cloud.png"];
        cloud.position = ccp(CCRANDOM_0_1() * _winSize.width, (CCRANDOM_0_1() * 200) + _winSize.height / 2);
        [_skyLayer addChild:cloud];
    }
    
    CCSprite *mountains = [CCSprite spriteWithFile:@"BackgroundMountains.png"];
    mountains.anchorPoint = ccp(0, 0);
    [self addChild:mountains];
    
    CCSprite *landscape = [CCSprite spriteWithFile:@"Landscape.png"];
    landscape.anchorPoint = ccp(0, 0);
    [self addChild:landscape];
}

- (void)generateRandomWind
{
    _windSpeed = CCRANDOM_MINUS1_1() * [_configuration[@"windMaxSpeed"] floatValue];
}


#pragma mark - Update

- (void)update:(ccTime)delta
{
    // Update logic goes here
    
    for (CCSprite *cloud in _skyLayer.children)
    {
        CGFloat cloudHalfWidth = cloud.contentSize.width / 2;
        CGPoint newPosition = ccp(cloud.position.x + (_windSpeed * delta), cloud.position.y);
        if (newPosition.x < -cloudHalfWidth)
        {
            newPosition.x = _skyLayer.contentSize.width + cloudHalfWidth;
        }
        else if (newPosition.x > (_skyLayer.contentSize.width + cloudHalfWidth))
        {
            newPosition.x = -cloudHalfWidth;
        }

        
        cloud.position = newPosition;
    }
}

#pragma mark - My Touch Delegate Methods

- (void)touchEnded
{
    [_tank jump];
}

@end
