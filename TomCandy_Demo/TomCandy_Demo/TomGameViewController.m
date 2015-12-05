//
//  GameViewController.m
//  TomCandy_Demo
//
//  Created by admin on 11/24/15.
//  Copyright (c) 2015 nguyenhuuden. All rights reserved.
//

#import "TomGameViewController.h"
#import "TomScene.h"
#import "TomLevel.h"


@interface TomGameViewController ()

@property (nonatomic, strong) TomScene *gameScene;
@property (nonatomic, strong) TomLevel *level;

@end

@implementation TomGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // retrieve the SCNView
    SKView *skView = (SKView *)self.view;
    skView.multipleTouchEnabled = NO;
    
    self.gameScene = [TomScene sceneWithSize:skView.bounds.size];
    self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Load the Tom level
//    self.level = [[TomLevel alloc] init];
    self.level = [[TomLevel alloc] initWithFile:@"Level_1"];
    self.gameScene.level = self.level;
    
    [self.gameScene addTiles];
    
    // Present the scene
    [skView presentScene:self.gameScene];
    
    
    
    // Let's start begin game
    [self beginGame];
    

    
}

- (void)shuffle
{
    NSSet *newToms = [self.level shuffle];
    [self.gameScene addSpriteForTom:newToms];
}

- (void)beginGame
{
    [self shuffle];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


@end
