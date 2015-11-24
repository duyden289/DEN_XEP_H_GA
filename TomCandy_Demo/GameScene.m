//
//  GameScene.m
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

/**
 * Init with size
 */
- (id)initWithSize:(CGSize)size
{
    
    if (self == [super initWithSize:size]) {
        
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        SKSpriteNode *backGround = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
        [self addChild:backGround];
    }
    return self;
    
}

@end
