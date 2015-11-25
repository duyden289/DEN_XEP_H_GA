//
//  GameViewController.m
//  TomCandy_Demo
//
//  Created by admin on 11/24/15.
//  Copyright (c) 2015 nguyenhuuden. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "TomLevel.h"


@interface GameViewController ()

@property (nonatomic, strong) GameScene *gameScene;
@property (nonatomic, strong) TomLevel *level;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // retrieve the SCNView
    SKView *skView = (SKView *)self.view;
    skView.multipleTouchEnabled = NO;
    
    self.gameScene = [GameScene sceneWithSize:skView.bounds.size];
    self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Load the Tom level
    self.level = [[TomLevel alloc] init];
    self.gameScene.level = self.level;
    
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
