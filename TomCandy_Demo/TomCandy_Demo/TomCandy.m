//
//  TomCandy.m
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "TomCandy.h"

@implementation TomCandy
- (NSString *)spriteName
{
    static NSString *const spriteName[]= {
        
        @"Croissant",
        @"Cupcake",
        @"Danish",
        @"Donut",
        @"Macaroon",
        @"SugarCookie"
    };
    
    return spriteName[self.tomType - 1];
}

- (NSString *)highlightedSpriteName
{
    static NSString *const hightlightedSpriteName[] =
    {
        @"Croissant-Highlighted",
        @"Cupcake-Highlighted",
        @"Danish-Highlighted",
        @"Donut-Highlighted",
        @"Macaroon-Highlighted",
        @"SugarCookie-Highlighted",
    };
    
    return hightlightedSpriteName[self.tomType - 1];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"type:%ld square: (%ld, %ld)", (long)self.tomType, (long)self.column, (long)self.row];
}
@end
