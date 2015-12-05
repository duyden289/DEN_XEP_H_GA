//
//  TomLevel.m
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "TomLevel.h"

//@interface TomLevel()
//{
//    TomCandy *_tom[]
//}
//
//@end

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
            
            //2
            
            NSUInteger tomType = arc4random_uniform(NumTomTypes) + 1;
            
            //3
            TomCandy *tom = [self createTomAtColumn:column row:row withType:tomType];
            
            //4
            [set addObject:tom];
            
        }
    }
    return set;
}

- (NSSet *)shuffle
{
   return [self createInitialToms];
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

@end
