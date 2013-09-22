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
#import "ChipmunkAutoGeometry.h"

@implementation GameScene

#pragma mark - Initilization

- (id)init
{
    self = [super init];
    if (self)
    {
        srandom(time(NULL));
        _winSize = [CCDirector sharedDirector].winSize;
        
        // Load configuration file
        _configuration = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"]];
        
        // Create physics world
        _space = [[ChipmunkSpace alloc] init];
        CGFloat gravity = [_configuration[@"gravity"] floatValue];
        _space.gravity = ccp(0.0f, -gravity);
        
        // Setup world
        [self generateRandomWind];
        [self setupGraphicsLandscape];
        [self setupPhysicsLandscape];
        
        // Create debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = NO;
        [self addChild:debugNode];
        
        // Add a tank
        NSString *tankPositionString = _configuration[@"tankPosition"];
        _tank = [[Tank alloc] initWithSpace:_space position:CGPointFromString(tankPositionString)];
        [_gameNode addChild:_tank];
        
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
    
    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode];
    
    CCSprite *mountains = [CCSprite spriteWithFile:@"BackgroundMountains.png"];
    mountains.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:mountains z:0 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *landscape = [CCSprite spriteWithFile:@"Landscape.png"];
    landscape.anchorPoint = ccp(0, 0);
    _landscapeWidth = landscape.contentSize.width;
    [_parallaxNode addChild:landscape z:1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _gameNode = [CCNode node];
    [_parallaxNode addChild:_gameNode z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
}

- (void)setupPhysicsLandscape
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Landscape" withExtension:@"png"];
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray *terrainShapes = [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in terrainShapes)
    {
        [_space addShape:shape];
    }
}

- (void)generateRandomWind
{
    _windSpeed = CCRANDOM_MINUS1_1() * [_configuration[@"windMaxSpeed"] floatValue];
}


#pragma mark - Update

- (void)update:(ccTime)delta
{
    CGFloat fixedTimeStep = 1.0f / 240.0f;
    _accumulator += delta;
    while (_accumulator > fixedTimeStep)
    {
        [_space step:fixedTimeStep];
        _accumulator -= fixedTimeStep;
    }
    
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
    
    if (_followTank == YES)
    {
        if (_tank.position.x >= (_winSize.width / 2) && _tank.position.x < (_landscapeWidth - (_winSize.width / 2)))
        {
            _parallaxNode.position = ccp(-(_tank.position.x - (_winSize.width / 2)), 0);
        }
    }
}

#pragma mark - My Touch Delegate Methods

- (void)touchEndedAtPositon:(CGPoint)position afterDelay:(NSTimeInterval)delay
{
    _followTank = YES;
    cpVect normalizedVector = cpvnormalize(cpvsub(position, _tank.position));
    [_tank jumpWithPower:delay * 300 vector:normalizedVector];
}

@end
