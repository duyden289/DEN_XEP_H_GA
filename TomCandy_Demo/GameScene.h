//
//  GameScene.h
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@class TomLevel;

@interface GameScene : SKScene

@property (nonatomic, strong) TomLevel *level;

- (void)addSpriteForTom: (NSSet *)toms;

@end
