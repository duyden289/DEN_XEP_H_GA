//
//  TomSwap.m
//  TomCandy_Demo
//
//  Created by admin on 12/5/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import "TomSwap.h"

@implementation TomSwap

- (NSString *)description
{
    return [NSString stringWithFormat:@" %@ Swap %@ with %@", [super description], self.tomCandyA, self.tomCandyB];
}

@end
