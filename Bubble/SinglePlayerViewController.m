//
//  ViewController.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

///
///SSEE SECONDVIEWCONTROLLER.M TO GET STARTED
///

#import "SinglePlayerViewController.h"
#import "SinglePlayerScene.h"
#import <SpriteKit/SpriteKit.h>

@implementation SinglePlayerViewController
SinglePlayerScene *scene;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //SinglePlayerScene *scene;
    SKView * skView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = skView;
    skView.showsFPS = YES;
    skView.showsNodeCount = NO;
    
    [self setUpUI];
    
    // Create and configure the scene.
    scene = [SinglePlayerScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene.
    [skView presentScene:scene];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popCurrentView) name:@"single_quit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popCurrentView) name:@"single_gameover" object:nil];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (IBAction)popCurrentView {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:scene];
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSUInteger)supportedInterfaceOrientations
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

- (void) setUpUI{
    
    UIImage *pauseButtonBackground = [UIImage imageNamed:@"pause_button.png"];
    
    self.pauseButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [self.pauseButton setFrame:CGRectMake(self.view.bounds.size.width - 30,
                                          10, 20.0, 25.0)];
    [self.pauseButton setBackgroundImage:pauseButtonBackground forState:UIControlStateNormal];
    [self.pauseButton addTarget:self action:@selector(drawPause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseButton];
}

- (IBAction)drawPause{
    PauseViewController *pauseMenu = [[PauseViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:pauseMenu animated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"single_pause" object:nil];
}
@end

