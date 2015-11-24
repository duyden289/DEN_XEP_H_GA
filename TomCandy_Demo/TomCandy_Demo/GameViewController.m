//
//  GameViewController.m
//  TomCandy_Demo
//
//  Created by admin on 11/24/15.
//  Copyright (c) 2015 nguyenhuuden. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController ()

@property (nonatomic, strong) GameScene *gameScene;

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
    
    // Present the scene
    [skView presentScene:self.gameScene];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
