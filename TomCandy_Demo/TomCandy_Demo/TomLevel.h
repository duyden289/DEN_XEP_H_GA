//
//  TomLevel.h
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TomCandy.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface TomLevel : NSObject

- (NSSet *)shuffle;

- (TomCandy *)tomAtCloumn: (NSInteger)column row:(NSInteger)row;

@end
