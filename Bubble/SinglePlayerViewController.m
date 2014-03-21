//
//  SinglePlayerViewController.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "SinglePlayerScene.h"
#include <AVFoundation/AVFoundation.h>

//uncomment the following line to display fps
//#define FPS

@implementation SinglePlayerViewController {
    SinglePlayerScene *scene;
    AVAudioPlayer*player;
}


-(void) sendScore:(long long)score
{
    
}

- (void)resumeMusic
{
    [player play];
}

- (void)pauseMusic
{
    [player pause];
}

- (void)viewDidLoad
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"singleplayer" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite loop
    if([player prepareToPlay])
    {
    [player play];
    }
        [super viewDidLoad];
    SKView * skView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = skView;
    
#ifndef FPS
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
#else
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
    
    [self setUpUI];
    
    // Create and configure the scene.
    scene = [SinglePlayerScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    scene.delegate = self;

    // Present the scene.
    [skView presentScene:scene];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popCurrentView) name:@"single_quit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeMusic) name:@"single_unpause" object:nil];

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
    [player stop];
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
    
    pauseButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [pauseButton setFrame:CGRectMake(self.view.bounds.size.width - 30,
                                          10, 20.0, 25.0)];
    [pauseButton setBackgroundImage:pauseButtonBackground forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(drawPause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    
    score = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 135, 10, 100, 25)];
    score.textAlignment = NSTextAlignmentRight;
    score.numberOfLines = 1;
    score.textColor = [UIColor whiteColor];
    score.text = @"";
    [self.view addSubview:score];
    
}

-(void)done:(NSString *)str{
    score.text = str;
}

- (IBAction)drawPause{
    [player pause];
    PauseViewController *pauseMenu = [[PauseViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:pauseMenu animated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"single_pause" object:nil];
}
@end

