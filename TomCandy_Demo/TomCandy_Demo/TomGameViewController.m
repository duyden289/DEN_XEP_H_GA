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

@property (nonatomic, strong) TomScene *tomScene;
@property (nonatomic, strong) TomLevel *level;

@property (nonatomic, assign) NSUInteger movesLeft;
@property (nonatomic, assign) NSUInteger score;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation TomGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // retrieve the SCNView
    SKView *skView = (SKView *)self.view;
    skView.multipleTouchEnabled = NO;
    
    self.tomScene = [TomScene sceneWithSize:skView.bounds.size];
    self.tomScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Load the Tom level
//    self.level = [[TomLevel alloc] init];
    self.level = [[TomLevel alloc] initWithFile:@"Level_0"];
    self.tomScene.level = self.level;
    
    [self.tomScene addTiles];
    
    id block = ^(TomSwap *tomSwap)
    {
        self.view.userInteractionEnabled = NO;
        if ([self.level isPossibleTomSwap:tomSwap]) {
            
            [self.level performTomSwap:tomSwap];
            [self.tomScene animateTomSwap:tomSwap completion:^{
                
                self.view.userInteractionEnabled = YES;
                [self handleTomChainMatches];
            }];
        }
        else
        {
            [self.tomScene animateInvalidTomSwap:tomSwap completion:^{
                
                self.view.userInteractionEnabled = YES;
            }];
        }
    };
    
    self.tomScene.swiperHandler = block;
    
    // Present the scene
    [skView presentScene:self.tomScene];
    
    
    
    // Let's start begin game
    [self beginGame];
    

    
}

- (void)shuffle
{
    NSSet *newToms = [self.level shuffle];
    [self.tomScene addSpriteForTom:newToms];
}

- (void)beginGame
{
    [self shuffle];
}

- (void)handleTomChainMatches
{
    NSSet *chains = [self.level removeMatches];
    if ([chains count] == 0) {
        
        [self beginNextTurn];
        return;
        
    }
    [self.tomScene animateMatchedTomCandy:chains completion:^{
       
        NSArray *columns = [self.level fillHoles];
        
        [self.tomScene animateFallingTomCandy:columns completion:^{
            
            NSArray *columns = [self.level topUpdaTomCandys];
            
            [self.tomScene animatedNewTomCandy:columns completion:^{
                
                self.view.userInteractionEnabled = YES;
            }];
        }];
        
    }];
}

- (void)beginNextTurn
{
    [self.level detectPossibleTomSwaps];
    self.view.userInteractionEnabled = YES;
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
