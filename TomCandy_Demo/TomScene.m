//
//  GameScene.m
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "TomScene.h"
#import "TomLevel.h"

static const CGFloat TileHeight = 32.0;
static const CGFloat TileWight = 36.0;

@interface TomScene ()

@property (nonatomic, strong) SKNode *gameLayer;
@property (nonatomic, strong) SKNode *tomLayer;
@property (nonatomic, strong) SKNode *titleLayer;
@property (nonatomic, assign) NSInteger swiperFromColumn;
@property (nonatomic, assign) NSInteger swiperFromRow;

@end

@implementation TomScene

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
        
        self.titleLayer = [SKNode node];
        self.titleLayer.position = layerPosition;
        [self.gameLayer addChild:self.titleLayer];
        
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

- (void)addTiles
{
    
    for (NSInteger row = 0; row < NumRows; row ++) {
        
        for (NSInteger column =0; column < NumColumns; column ++) {
            
            if ([self.level titleAtColumn:column row:row] != nil) {
                
                SKSpriteNode *titleNode = [SKSpriteNode spriteNodeWithImageNamed:@"Tile"];
                titleNode.position = [self pointForColumn:column row:row];
                
                [self.titleLayer addChild:titleNode];
                
            }
        }
        
    }
}

- (BOOL)convertPoint:(CGPoint)point toColumn:(NSInteger *)column row:(NSInteger *)row
{
    NSParameterAssert(column);
    NSParameterAssert(row);
    
    // Is this a valid location within the tom layer ? If Yes,
    // caculate the corresponding row and column numbers
    
    if (point.x >= 0 && point.x < NumColumns *TileWight && point.y >=0 && point.y < NumRows * TileHeight) {
        
        *column = point.x / TileWight;
        *row = point.y / TileHeight;
        
        return YES;
        
    }
    else
    {
        *column = NSNotFound; // In valid location
        *row = NSNotFound;
        return NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.tomLayer];
    
    //2
    NSInteger column, row;
    
    if ([self convertPoint:location toColumn:&column row:&row]) {
        
        // 3
        TomCandy *tomCandy = [self.level tomAtCloumn:column row:row];
        
        if (tomCandy != nil) {
            
            // 4
            self.swiperFromColumn = column;
            self.swiperFromRow = row;
        }
    }
   
}

@end
