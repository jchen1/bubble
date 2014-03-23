//
//  TwoPlayerViewController.m
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "TwoPlayerViewController.h"

@implementation TwoPlayerViewController{
    TwoPlayerScene *scene;
    SKView * skView;
}

@synthesize gc;

- (void) done:(NSString *)dataText{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    skView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    skView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.view = skView;
    
#ifndef FPS
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
#else
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
    
    UIImage *pauseButtonBackground = [UIImage imageNamed:@"pause_button.png"];
    
    pauseButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [pauseButton setFrame:CGRectMake(self.view.bounds.size.width - 30,
                                     10, 20.0, 25.0)];
    [pauseButton setBackgroundImage:pauseButtonBackground forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    
    scene = [TwoPlayerScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate=self;
    scene.gc = gc;
    gc.currentGameView = scene;
    [skView presentScene:scene];

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


- (IBAction)pause{
    [player pause];
    [scene pause];
    PauseViewController *pauseMenu = [[PauseViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:pauseMenu];
    [[self view] addSubview: [pauseMenu view]];
}

- (IBAction)resume
{
    if ([self.splash shouldPlayMusic]){
        [player play];
    }
    [scene unpause];
}


@end
