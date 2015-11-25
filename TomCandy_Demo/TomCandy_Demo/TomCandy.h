//
//  TomCandy.h
//  TomCandy_Demo
//
//  Created by admin on 11/25/15.
//  Copyright © 2015 nguyenhuuden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

static const NSUInteger NumTomTypes = 6;

@interface TomCandy : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSUInteger tomType;
@property (nonatomic, strong) SKSpriteNode *sprite;

- (NSString *)spriteName;
- (NSString *)highlightedSpriteName;

@end
