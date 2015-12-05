//
//  TomLevel.h
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TomCandy.h"
#import "TomTitle.h"
#import "TomSwap.h"
#import "TomChain.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface TomLevel : NSObject

- (NSSet *)shuffle;

- (TomCandy *)tomAtCloumn: (NSInteger)column row:(NSInteger)row;

- (instancetype)initWithFile:(NSString *)fileName;

- (TomTitle *)titleAtColumn:(NSInteger)column row:(NSInteger)row;

- (void)performTomSwap:(TomSwap *)tomSwap;

- (BOOL)isPossibleTomSwap:(TomSwap *)tomSwap;

/**
 *  Remove matches
 *
 *  @return a array set has remove
 */
- (NSSet *)removeMatches;
@end
