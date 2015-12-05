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

@property (nonatomic, strong) SKSpriteNode *selectionSprite;

// Sound property
@property (nonatomic, strong) SKAction *swapSound;
@property (nonatomic, strong) SKAction *invalidSwapSound;
@property (nonatomic, strong) SKAction *matchSound;
@property (nonatomic, strong) SKAction *faillingTomCandySound;
@property (nonatomic, strong) SKAction *addTomCandySound;

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
        
        self.selectionSprite = [SKSpriteNode node];
        
        [self preloadSoundResource];
        
        
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
            
            [self showSelectionIndicatorForTomCandy:tomCandy];
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
            
            [self hideSelectionIndicator];
            
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
//    self.swiperFromColumn = self.swiperFromRow = NSNotFound;
    if (self.selectionSprite.parent != nil && self.swiperFromColumn != NSNotFound) {
        
        [self hideSelectionIndicator];
    }
    NSLog(@"Touch End");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
    NSLog(@"Touch Cancel");
}



/**
 *  Highlight for image
 */
- (void)showSelectionIndicatorForTomCandy:(TomCandy *)tomCandy
{
    // If the seletion indicator is still visable then first remove
    
    if (self.selectionSprite.parent != nil) {
        
        [self.selectionSprite removeFromParent];
    }
    SKTexture *textture = [SKTexture textureWithImageNamed:[tomCandy highlightedSpriteName]];
    
    self.selectionSprite.size = textture.size;
    [self.selectionSprite runAction:[SKAction setTexture:textture]];
    
    [tomCandy.sprite addChild:self.selectionSprite];
    self.selectionSprite.alpha = 1.0;
}

/**
 *  Hide selection indicator
 */
- (void)hideSelectionIndicator
{
    [self.selectionSprite runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.3], [SKAction removeFromParent]]]];
}

- (void)animateTomSwap:(TomSwap *)tomSwap completion:(dispatch_block_t)completion
{
    // Put the tom candy you started with o top
    tomSwap.tomCandyA.sprite.zPosition = 100;
    tomSwap.tomCandyB.sprite.zPosition = 90;
    
    const NSTimeInterval duration = 0.3;
    
    SKAction *moveTomA = [SKAction moveTo:tomSwap.tomCandyB.sprite.position duration:duration];
    moveTomA.timingMode = SKActionTimingEaseOut;
    
    SKAction *moveTomB = [SKAction moveTo:tomSwap.tomCandyA.sprite.position duration:duration];
    moveTomB.timingMode = SKActionTimingEaseOut;
    
    [tomSwap.tomCandyA.sprite runAction:[SKAction sequence:@[moveTomA, [SKAction runBlock:completion]]]];
    
    [tomSwap.tomCandyB.sprite runAction:moveTomB];
    
    [self runAction:self.swapSound];
    
}

- (void)animateInvalidTomSwap: (TomSwap *)tomSwap completion:(dispatch_block_t)completion
{
    tomSwap.tomCandyA.sprite.zPosition = 100;
    tomSwap.tomCandyB.sprite.zPosition = 90;
    
    const NSTimeInterval duration = 0.2;
    
    SKAction *moveTomA = [SKAction moveTo:tomSwap.tomCandyB.sprite.position duration:duration];
    moveTomA.timingMode = SKActionTimingEaseOut;
    
    SKAction *moveTomB = [SKAction moveTo:tomSwap.tomCandyA.sprite.position duration:duration];
    moveTomB.timingMode = SKActionTimingEaseOut;
    
    [tomSwap.tomCandyA.sprite runAction:[SKAction sequence:@[moveTomA, moveTomB, [SKAction runBlock:completion]]]];
    
    [tomSwap.tomCandyB.sprite runAction:[SKAction sequence:@[moveTomB, moveTomA]]];
    
    [self runAction:self.invalidSwapSound];
}

- (void)preloadSoundResource
{
    self.swapSound = [SKAction playSoundFileNamed:@"Chomp.wav" waitForCompletion:NO];
    
    self.invalidSwapSound = [SKAction playSoundFileNamed:@"Error.wav" waitForCompletion:NO];
    
    self.matchSound = [SKAction playSoundFileNamed:@"Ka-Ching.wav" waitForCompletion:NO];
    
    self.faillingTomCandySound = [SKAction playSoundFileNamed:@"Scrape.wav" waitForCompletion:NO];
    
    self.addTomCandySound = [SKAction playSoundFileNamed:@"Drip.wav" waitForCompletion:NO];
    
    
}

- (void)animateMatchedTomCandy: (NSSet *)tomChains completion:(dispatch_block_t)completion
{
    for (TomChain *chain in tomChains) {
        
        for (TomCandy *tomCandy in chain.tomCandys) {
            
            //1
            if (tomCandy.sprite != nil) {
                
                //2
                SKAction *scaleAction = [SKAction scaleTo:0.1 duration:0.3];
                
                scaleAction.timingMode = SKActionTimingEaseOut;
                
                [tomCandy.sprite runAction:[SKAction sequence:@[scaleAction, [SKAction removeFromParent]]]];
                
                //3
                tomCandy.sprite = nil;
                
            }
        }
    }
    [self runAction:self.matchSound];
    
    //4
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.3], [SKAction runBlock:completion]]]];
    
}

- (void)animateFallingTomCandy:(NSArray *)columns completion:(dispatch_block_t)completion
{
    //1
    __block NSTimeInterval longestDuration = 0;
    
    for (NSArray *array  in columns) {
        
        [array enumerateObjectsUsingBlock:^(TomCandy *tomCandy, NSUInteger idx, BOOL * stop) {
            
            CGPoint newPostion = [self pointForColumn:tomCandy.column row:tomCandy.row];
            
            //2
            NSTimeInterval delay = 0.05 + 0.15*idx;
            
            //3
            
            NSTimeInterval duration = ((tomCandy.sprite.position.y - newPostion.y) / TileHeight) *0.1;
            
            //4
            longestDuration = MAX(longestDuration, duration + delay);
            
            //5
            SKAction *moveAction = [SKAction moveTo:newPostion duration:duration];
            moveAction.timingMode = SKActionTimingEaseOut;
            
            [tomCandy.sprite runAction:[SKAction sequence:@[[SKAction waitForDuration:delay], [SKAction group:@[moveAction, self.faillingTomCandySound]]]]];
            
        }];
    }
    
    //6
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:longestDuration], [SKAction runBlock:completion]]]];
}

// Adding new tom candy
- (void)animatedNewTomCandy:(NSArray *)columns completion:(dispatch_block_t)completion
{
    //1
    __block NSTimeInterval longestDuration = 0;
    
    for (NSArray *array in columns) {
        
        //2
        NSInteger startRow = ((TomCandy *)[array firstObject]).row + 1;
        
        [array enumerateObjectsUsingBlock:^(TomCandy *tomCandy, NSUInteger idx, BOOL * stop) {
            
            //3
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[tomCandy spriteName]];
            sprite.position = [self pointForColumn:tomCandy.column row:startRow];
            
            [self.tomLayer addChild:sprite];
            tomCandy.sprite = sprite;
            
            //4
            NSTimeInterval delay = 0.1 + 0.2*([array count]) - idx - 1;
            
            //5
            NSTimeInterval duration = (startRow - tomCandy.row) * 0.1;
            longestDuration = MAX(longestDuration, duration + delay);
            
            //6
            CGPoint newPosition = [self pointForColumn:tomCandy.column row:tomCandy.row];
            
            SKAction *moveAction = [SKAction moveTo:newPosition duration:duration];
            moveAction.timingMode = SKActionTimingEaseOut;
            
            tomCandy.sprite.alpha = 0;
            
            [tomCandy.sprite runAction:[SKAction sequence:@[[SKAction waitForDuration:delay], [SKAction group:@[[SKAction fadeInWithDuration:0.05], moveAction, self.addTomCandySound]]]]];
        }];
    }
    
    //7
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:longestDuration], [SKAction runBlock:completion]]]];
}
@end
