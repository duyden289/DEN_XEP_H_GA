//
//  TomChain.m
//  TomCandy_Demo
//
//  Created by admin on 12/5/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "TomChain.h"
#import "TomCandy.h"

@implementation TomChain
{
    NSMutableArray *_tomCandyArray;
}

- (void)addTomCandy:(TomCandy *)tomCandy
{
    if (_tomCandyArray == nil) {
        
        _tomCandyArray = [NSMutableArray array];
    }
    
    [_tomCandyArray addObject:tomCandy];
}

-(NSArray *)tomCandys
{
    return _tomCandyArray;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Type :%ld tomcandy:%@", (long)self.tomChainType, self.tomCandys];
}
@end
