//
//  GameScene.h
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@class TomLevel;
@class TomSwap;

@interface TomScene : SKScene

@property (nonatomic, strong) TomLevel *level;

- (void)addSpriteForTom: (NSSet *)toms;
- (void)addTiles;

@property (nonatomic, copy) void(^swiperHandler)(TomSwap *tomSwap);

- (void)animateTomSwap:(TomSwap *)tomSwap completion:(dispatch_block_t)completion;
@end
