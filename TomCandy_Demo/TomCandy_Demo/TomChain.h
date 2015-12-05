//
//  TomChain.h
//  TomCandy_Demo
//
//  Created by admin on 12/5/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TomCandy;

typedef NS_ENUM(NSUInteger, TomChainType)
{
    TomChainTypeHorizontal,
    TomChainTypeVeritical
    
};

@interface TomChain : NSObject

@property (nonatomic, strong, readonly) NSArray *tomCandys;
@property (nonatomic, assign) TomChainType tomChainType;

- (void)addTomCandy:(TomCandy *)tomCandy;

@end
