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



@end
