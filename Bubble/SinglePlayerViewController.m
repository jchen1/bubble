//
//  SinglePlayerViewController.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "SinglePlayerScene.h"

//uncomment the following line to display fps
//#define FPS

@implementation SinglePlayerViewController {
    SinglePlayerScene *scene;
}

- (void)pauseMusic
{
    [player pause];
}

-(void) resumeMusic
{
    [player play];
}

- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float musicVolume = [defaults floatForKey:@"musicVolume"];
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"singleplayer" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite loop
    player.volume = (musicVolume == 0) ? 1.0 : musicVolume;
    
    if ([self.splash shouldPlayMusic]){
        if([player prepareToPlay]){
            [player play];
        }
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
    
    scene = [SinglePlayerScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    scene.gc = [self gc];
    [skView presentScene:scene];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popCurrentView) name:@"gameQuit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pause) name:@"gamePause" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resume) name:@"gameUnpause" object:nil];

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
    [pauseButton setFrame:CGRectMake(self.view.bounds.size.width - 35,
                                          15, 20.0, 25.0)];
    [pauseButton setBackgroundImage:pauseButtonBackground forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    
    score = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 140, 15, 100, 25)];
    score.textAlignment = NSTextAlignmentRight;
    score.numberOfLines = 1;
    score.textColor = [UIColor whiteColor];
    score.text = @"";
    [self.view addSubview:score];
    
}

-(void)done:(NSString *)str{
    score.text = str;
}

- (IBAction)pause{
    [player pause];
    if (![scene isPaused]){
        [scene pause];
        PauseViewController *pauseMenu = [[PauseViewController alloc] initWithNibName:nil bundle:nil];
        [self addChildViewController:pauseMenu];
        [[self view] addSubview: [pauseMenu view]];
    }
}

- (IBAction)resume
{
    if ([self.splash shouldPlayMusic]){
        [player play];
    }
    [scene unpause];
}

@end

