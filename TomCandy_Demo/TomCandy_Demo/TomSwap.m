//
//  TomSwap.m
//  TomCandy_Demo
//
//  Created by admin on 12/5/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "TomSwap.h"
#import "TomCandy.h"

@implementation TomSwap

- (NSString *)description
{
    return [NSString stringWithFormat:@" %@ Swap %@ with %@", [super description], self.tomCandyA, self.tomCandyB];
}

- (BOOL)isEqual:(id)object
{
    // Compare this object againts other tom swap object
    
    if (![object isKindOfClass:[TomSwap class]]) {
        
        NSLog(@"Don't have to TomSwap Class");
        return NO;
        
        
    }
    
    TomSwap *otherTomSwap = (TomSwap *)object;
    return (otherTomSwap.tomCandyA == self.tomCandyA && otherTomSwap.tomCandyB == self.tomCandyB) || (otherTomSwap.tomCandyB == self.tomCandyA && otherTomSwap.tomCandyA == self.tomCandyB);
}

- (NSUInteger)hash
{
    return [self.tomCandyA hash] ^ [self.tomCandyB hash];
}
@end
