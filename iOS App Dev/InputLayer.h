//
//  InputLayer.h
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/19/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol InputLayerDelegate <NSObject>

- (void)touchEnded;

@end

@interface InputLayer : CCLayer

@property (nonatomic, weak) id<InputLayerDelegate> delegate;

@end
