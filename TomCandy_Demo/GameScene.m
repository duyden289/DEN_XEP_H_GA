//
//  GameScene.m
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "GameScene.h"
#import "TomLevel.h"

static const CGFloat TileHeight = 32.0;
static const CGFloat TileWight = 36.0;

@interface GameScene ()

@property (nonatomic, strong) SKNode *gameLayer;
@property (nonatomic, strong) SKNode *tomLayer;

@end

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
        
        self.gameLayer = [SKNode node];
        [self addChild:self.gameLayer];
        
        CGPoint layerPosition = CGPointMake(-TileWight *NumColumns / 2, -TileHeight *NumRows / 2);
        
        self.tomLayer = [SKNode node];
        self.tomLayer.position = layerPosition;
        
        [self.gameLayer addChild:self.tomLayer];
    }
    return self;
    
}

- (CGPoint)pointForColumn: (NSInteger)column row:(NSInteger)row
{
    return CGPointMake(column *TileWight +TileWight/2, row*TileHeight + TileHeight/2);
}

- (void)addSpriteForTom:(NSSet *)toms
{
    for (TomCandy *tom in toms) {
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[tom spriteName]];
        sprite.position = [self pointForColumn:tom.column row:tom.row];
        
        [self.tomLayer addChild:sprite];
        tom.sprite = sprite;
    }
}

@end
