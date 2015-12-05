//
//  GameScene.m
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "TomScene.h"
#import "TomLevel.h"
#import "TomSwap.h"

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
        
        self.titleLayer = [SKNode node];
        self.titleLayer.position = layerPosition;
        [self.gameLayer addChild:self.titleLayer];

        
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

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1
    if (self.swiperFromColumn == NSNotFound) {
        return;
    }
    
    //2
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.tomLayer];
    
    NSInteger coloumn, row;
    
    if ([self convertPoint:location toColumn:&coloumn row:&row]) {
        
        // 3
        NSInteger horizontalDelta = 0, veriticalDelta = 0;
        
        if (coloumn < self.swiperFromColumn) { // swiper left
            
            horizontalDelta = -1;
        }
        else if (coloumn > self.swiperFromColumn) // swiper right
        {
            horizontalDelta = 1;
            
        }
        else if (row < self.swiperFromRow) // swiper down
        {
            veriticalDelta = -1 ;
        }
        else if (row > self.swiperFromRow)
        {
            veriticalDelta = 1;
        }
        
        //4
        if (horizontalDelta != 0 || veriticalDelta != 0) {
            
            [self trySwapHorizontal:horizontalDelta veriticalDelta:veriticalDelta];
            
         // 5
            self.swiperFromColumn = NSNotFound;
        }
        
        
        
        
    }
}

- (void)trySwapHorizontal: (NSInteger)horizontalDetal veriticalDelta:(NSInteger)veriticalDelta
{
    // 1
    NSInteger toColumn = self.swiperFromColumn + horizontalDetal;
    NSInteger toRow = self.swiperFromRow + veriticalDelta;
    
    // 2
    if (toColumn < 0 || toColumn >= NumColumns) {
        return;
    }
    if (toRow < 0 || toRow >= NumRows) {
        return;
    }
    
    //3
    TomCandy *toTomCandy = [self.level tomAtCloumn:toColumn row:toRow];
    
    if (toTomCandy == nil) {
        return;
    }
    
    TomCandy *fromTomCandy = [self.level tomAtCloumn:self.swiperFromColumn row:self.swiperFromRow];
    
    if (self.swiperHandler != nil) {
        
        TomSwap *tomSwap = [[TomSwap alloc] init];
        tomSwap.tomCandyA = fromTomCandy;
        tomSwap.tomCandyB = toTomCandy;
        
        self.swiperHandler(tomSwap);
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.swiperFromColumn = self.swiperFromRow = NSNotFound;
    NSLog(@"Touch End");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
    NSLog(@"Touch Cancel");
}

- (void)animateTomSwap:(TomSwap *)tomSwap completion:(dispatch_block_t)completion
{
    // Put the tom candy you started with o top
    tomSwap.tomCandyA.sprite.zPosition = 100;
    tomSwap.tomCandyB.sprite.zPosition = 90;
    
    const NSTimeInterval duration = 0.3;
    
    SKAction *moveTomA = [SKAction moveTo:tomSwap.tomCandyB.sprite.position duration:duration];
    moveTomA.timingMode = SKActionTimingEaseOut;
    
    [tomSwap.tomCandyA.sprite runAction:[SKAction sequence:@[moveTomA, [SKAction runBlock:completion]]]];
    
    SKAction *moveTomB = [SKAction moveTo:tomSwap.tomCandyA.sprite.position duration:duration];
    moveTomB.timingMode = SKActionTimingEaseOut;
    
    [tomSwap.tomCandyB.sprite runAction:moveTomB];
    
}

@end
