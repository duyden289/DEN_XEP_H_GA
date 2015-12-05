//
//  TomLevel.m
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "TomLevel.h"

@interface TomLevel()

@property (nonatomic, strong) NSSet *possibleTomSwaps;

@end

@implementation TomLevel
{
    TomCandy *_tom[NumColumns][NumRows];
    TomTitle *_title[NumColumns][NumRows];
}
- (TomCandy *)tomAtCloumn:(NSInteger)column row:(NSInteger)row
{
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column : %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid : %ld", (long)row);
    
    return _tom[column][row];
    
}

- (TomCandy *)createTomAtColumn: (NSInteger)column row:(NSInteger)row withType:(NSUInteger)tomType
{
    TomCandy *tom = [[TomCandy alloc] init];
    tom.tomType = tomType;
    tom.column = column;
    tom.row = row;
    
    _tom[column][row] = tom;
    
    return tom;
}

- (NSSet *)createInitialToms
{
    
    NSMutableSet *set = [[NSMutableSet alloc] init];
    
    // 1
    for (NSInteger row = 0; row < NumRows; row ++) {
        
        for (NSInteger column = 0; column < NumColumns; column ++) {
            
            if (_title[column][row] != nil) {
                
                NSUInteger tomType;
                //2
                
                do
                {
                    tomType = arc4random_uniform(NumTomTypes) + 1;
                }
                while ((column >= 2 && _tom[column - 1][row].tomType == tomType && _tom[column - 2][row].tomType == tomType) || (row >= 2 && _tom[column][row - 1].tomType == tomType && _tom[column][row - 2].tomType == tomType));
                //3
                TomCandy *tom = [self createTomAtColumn:column row:row withType:tomType];
                
                //4
                [set addObject:tom];
            }
            
        }
    }
    return set;
}

- (NSSet *)shuffle
{
    NSSet *set;
    
    do
    {
        set = [self createInitialToms];
        
        [self detectPossibleTomSwaps];
        
        NSLog(@"Possible tom swap %@", self.possibleTomSwaps);
    }
    while ([self.possibleTomSwaps count] == 0);
    
    return set;
}

- (NSDictionary *)loadJSON: (NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    if (path == nil) {
        NSLog(@"Could not find level file: %@", fileName);
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (data == nil) {
        NSLog(@"Could not load level file: %@, error: %@", fileName, error);
        return nil;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Level file '%@' is not valid JSON: %@", fileName, error);
        return nil;
    }
    
    return dictionary;
}

- (instancetype )initWithFile:(NSString *)fileName
{
    self = [super init];
    if (self != nil) {
        NSDictionary *dictionary = [self loadJSON:fileName];
        
        // Loop through the rows
        [dictionary[@"tiles"] enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
            
            // Loop through the columns in the current row
            [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop) {
                
                // Note: In Sprite Kit (0,0) is at the bottom of the screen,
                // so we need to read this file upside down.
                NSInteger tileRow = NumRows - row - 1;
                
                // If the value is 1, create a tile object.
                if ([value integerValue] == 1) {
                    
                    _title[column][tileRow] = [[TomTitle alloc] init];
                }
            }];
        }];
    }
    return self;
}

- (TomTitle *)titleAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _title[column][row];
}

- (void)performTomSwap:(TomSwap *)tomSwap
{
    NSInteger coloumnA = tomSwap.tomCandyA.column;
    NSInteger rowA = tomSwap.tomCandyA.row;
    
    NSInteger coloumnB = tomSwap.tomCandyB.column;
    NSInteger rowB = tomSwap.tomCandyB.row;
    
    _tom[coloumnA][rowA] = tomSwap.tomCandyB;
    tomSwap.tomCandyB.column = coloumnA;
    tomSwap.tomCandyB.row = rowA;
    
    _tom[coloumnB][rowB] = tomSwap.tomCandyA;
    tomSwap.tomCandyA.column = coloumnB;
    tomSwap.tomCandyA.row = rowB;
}

- (BOOL)hasChainAtColumn:(NSInteger)column row:(NSInteger)row
{
    NSUInteger tomType = _tom[column][row].tomType;
    
    NSUInteger horizontalLenght = 1;
    
    for (NSInteger i = column - 1; i >= 0 && _tom[i][row].tomType == tomType; i --, horizontalLenght ++ );
    for (NSInteger i = column + 1; i< NumColumns && _tom[i][row].tomType == tomType ; i++, horizontalLenght ++);
    
    if (horizontalLenght >= 3) return YES;
    
    
    NSUInteger verticalLenght = 1;
    for (NSInteger i = row - 1; i >=0 && _tom[column][i].tomType == tomType ; i--, verticalLenght ++);
    
    for (NSInteger i = row + 1; i < NumRows && _tom[column][i].tomType == tomType; i++, verticalLenght ++){}
    
        return (verticalLenght >= 3);
}

- (void)detectPossibleTomSwaps
{
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        
        for (NSInteger column = 0; column < NumColumns; column ++) {
            
            TomCandy *tomCandy = _tom[column][row];
            
            if (tomCandy != nil) {
                
                if (column < NumColumns - 1) {
                    
                    TomCandy *otherTomCandy = _tom[column + 1][row];
                    
                    if (otherTomCandy != nil) {
                        
                        // Swap them
                        _tom[column][row] = otherTomCandy;
                        _tom[column + 1][row] = tomCandy;
                        
                        // Is either tom candy now part of a chain?
                        if ([self hasChainAtColumn:column + 1 row:row] || [self hasChainAtColumn:column row:row]) {
                            
                            TomSwap *tomSwap = [[TomSwap alloc] init];
                            tomSwap.tomCandyA = tomCandy;
                            tomSwap.tomCandyB = otherTomCandy;
                            
                            [set addObject:tomSwap];
                        }
                      
                        // Swap them back
                        _tom[column][row] = tomCandy;
                        _tom[column +1 ][row] = otherTomCandy;
                    }
                }
                
                if (row < NumRows - 1) {
                    
                    TomCandy *otherTomCandy = _tom[column][row + 1];
                    if (otherTomCandy != nil) {
                        
                        // Swap them
                        _tom[column][row] = otherTomCandy;
                        _tom[column][row + 1] = tomCandy;
                        
                        if ([self hasChainAtColumn:column row:row + 1] || [self hasChainAtColumn:column row:row]) {
                            
                            TomSwap *tomSwap = [[TomSwap alloc] init];
                            tomSwap.tomCandyA = tomCandy;
                            tomSwap.tomCandyB = otherTomCandy;
                            
                            [set addObject:tomSwap];
                        }
                        
                        // Swap back them
                        _tom[column][row] = tomCandy;
                        _tom[column][row + 1] = otherTomCandy;
                    }
                }
                
            }
        }
        
    }
    self.possibleTomSwaps = set;
}

- (BOOL)isPossibleTomSwap:(TomSwap *)tomSwap
{
    return [self.possibleTomSwaps containsObject:tomSwap];
}

/**
 *  Scan with horizontal matches
 *
 *  @return a set has detect
 */
- (NSSet *)detectHorizontalMatches
{
    //1
    NSMutableSet *set = [NSMutableSet set];
    
    //2
    for (NSInteger row = 0; row < NumRows; row ++) {
        
        for (NSInteger column = 0; column < NumColumns - 2 ;) {
            
            //3
            if (_tom[column][row] != nil) {
                
                NSUInteger matchType = _tom[column][row].tomType;
                
                //4
                
                if (_tom[column + 1][row].tomType == matchType && _tom[column + 2][row].tomType == matchType) {
                    
                    TomChain *tomChain = [[TomChain alloc] init];
                    tomChain.tomChainType = TomChainTypeHorizontal;
                    
                    do
                    {
                        [tomChain addTomCandy:_tom[column][row]];
                        column += 1;
                    }
                    while (column < NumColumns && _tom[column][row].tomType == matchType);
                    
                    [set addObject:tomChain];
                    
                    continue;
                    
                }
            }
            column += 1;
        }
    }
    return set;
}

/**
 *  Scan with veritical matches
 *
 *  @return a set has detect
 */
- (NSSet *)detectVeriticalMatches
{
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger coloumn = 0 ; coloumn < NumColumns; coloumn ++) {
        
        for (NSInteger row = 0; row < NumRows - 2; ) {
            
            if (_tom[coloumn][row] != nil) {
                
                NSUInteger matchType = _tom[coloumn][row].tomType;
                
                if (_tom[coloumn][row + 1].tomType == matchType && _tom[coloumn][row + 2].tomType == matchType) {
                    
                    TomChain *tomChain = [[TomChain alloc] init];
                    tomChain.tomChainType = TomChainTypeVeritical;
                    
                    do
                    {
                        [tomChain addTomCandy:_tom[coloumn][row]];
                        row += 1;
                    }
                    while (row < NumRows && _tom[coloumn][row].tomType == matchType);
                    
                    [set addObject:tomChain];
                    continue;
                }
            }
            row += 1;
        }
    }
    
    return set;
}

- (NSSet *)removeMatches
{
    NSSet *horizontalTomChain = [self detectHorizontalMatches];
    NSSet *veriticalTomChain = [self detectVeriticalMatches];
    
    [self removeTomCandy:horizontalTomChain];
    [self removeTomCandy:veriticalTomChain];
    
    return [horizontalTomChain setByAddingObjectsFromSet:veriticalTomChain];
}

- (void)removeTomCandy:(NSSet *)tomChains
{
    for (TomChain *chain in tomChains) {
        
        for (TomCandy *tomCandy in chain.tomCandys) {
            
            _tom[tomCandy.column][tomCandy.row] = nil;
        }
    }
}

@end
