//
//  SplashViewController.m
//  Bubble
//
//  Created by Jeff Chen on 9/27/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "SettingsViewController.h"
#import "SplashViewController.h"
#import "TwoPlayerViewController.h"


@implementation SplashViewController
{
    AVAudioPlayer*player;
}

@synthesize gcController = _controller;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pauseMusic) name:@"splashPause" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeMusic) name:@"splashResume" object:nil];

    [self setUpUI];
    //set the value of global variable highscore
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    highscore = [[defaults valueForKey:@"singleHighScore"] longValue];
}

- (IBAction)pauseMusic
{
    if (_playMusic){
        [player stop];
    }
}

-(IBAction)resumeMusic
{
    if (_playMusic){
        player.currentTime = 0;
        [player play];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)gameView {
    SinglePlayerViewController *gameView = [[SinglePlayerViewController alloc] init];
    [player stop];
    gameView.splash = self;
    gameView.gc = _controller;
    [self.navigationController pushViewController:gameView animated:NO];
}

- (IBAction)multiGameView {
#ifndef TWOPLAYER    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon!"
                                                    message:@"This feature is still in development."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#else
    [_controller findGame];
#endif
}

- (IBAction)optionsView {
    SettingsViewController *settingsView = [[SettingsViewController alloc] init];
    settingsView.splash = self;
    [self.gcController resetAchievements];
    [self.navigationController pushViewController:settingsView animated:NO];
}

- (IBAction)twitterView {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Check out this game! http://t.co/pAHoAtMxZ0 #bubbleOutlast"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Twitter Unavailable"
                                  message:@"Please sign in and make sure you have an Internet connection."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)gameCenterView{
    [_controller showLeaderboardAndAchievements:true];
}


- (void) setUpUI{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *singlePlayerButtonBackground = [UIImage imageNamed:@"1p_button.png"];
    UIImage *twoPlayerButtonBackground = [UIImage imageNamed:@"2p_button.png"];
    UIImage *optionsButtonBackground = [UIImage imageNamed:@"options_button.png"];
    UIImage *gameCenterButtonBackground = [UIImage imageNamed:@"game_center_logo.png"];
    UIImage *twitterButtonBackground = [UIImage imageNamed:@"twitter_logo.png"];
    UIImage *bubbleIconImage = [UIImage imageNamed:@"bubble_icon_title.png"];
    
    float width = self.view.bounds.size.width;
    float height = self.view.bounds.size.height;
    float buttonWidth = MIN(400, 0.6*width);
    float buttonHeight = 0.25 * buttonWidth;
    
    
    bubbleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.5 * width - 0.2 * height,
                                                               0.1 * height, 0.4 * height, 0.4 * height)];
    bubbleIcon.image = bubbleIconImage;
    [self.view addSubview:bubbleIcon];
    
    singlePlayerButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [singlePlayerButton setFrame:CGRectMake(0.5 * (width - buttonWidth),
                                            0.5 * height + buttonHeight, buttonWidth, buttonHeight)];
    [singlePlayerButton setBackgroundImage:singlePlayerButtonBackground forState:UIControlStateNormal];
    [singlePlayerButton addTarget:self action:@selector(gameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:singlePlayerButton];
    
    twoPlayerButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [twoPlayerButton setFrame:CGRectMake(0.5 * (width - buttonWidth),
                                         0.5 * height + 2.2*buttonHeight, buttonWidth, buttonHeight)];
    [twoPlayerButton setBackgroundImage:twoPlayerButtonBackground forState:UIControlStateNormal];
    [twoPlayerButton addTarget:self action:@selector(multiGameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoPlayerButton];

    optionsButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [optionsButton setFrame:CGRectMake(0.5 * (width - buttonWidth),
                                       0.5 * height + 3.4*buttonHeight, buttonWidth, buttonHeight)];
    [optionsButton setBackgroundImage:optionsButtonBackground forState:UIControlStateNormal];
    [optionsButton addTarget:self action:@selector(optionsView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:optionsButton];
    
    
    gameCenterButton =  [UIButton buttonWithType:UIButtonTypeSystem];
    [gameCenterButton setFrame:CGRectMake(0.01 * width, self.view.bounds.size.height - 0.06 * width,
                                          0.05 * width, 0.05 * width)];
    [gameCenterButton setBackgroundImage:gameCenterButtonBackground forState:UIControlStateNormal];
    [gameCenterButton addTarget:self action:@selector(gameCenterView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gameCenterButton];
    
    twitterButton =  [UIButton buttonWithType:UIButtonTypeSystem];
    [twitterButton setFrame:CGRectMake(0.07 * width, self.view.bounds.size.height - 0.06 * width,
                                       0.05 * width, 0.05 * width)];
    [twitterButton setBackgroundImage:twitterButtonBackground forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(twitterView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitterButton];
    
    
    float musicVolume = [defaults floatForKey:@"musicVolume"];
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"splash" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite loop
    player.volume = (musicVolume == 0) ? 1.0 : musicVolume;
    
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Listen to our music?"
                                  message:@"We have detected that you currently have music playing. Would you like to listen to our cleverly hand-picked background music instead?"
                                  delegate:self
                                  cancelButtonTitle:@"No"
                                  otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
    else {
        _playMusic = YES;
        if([player prepareToPlay]){
            [player play];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Listen to our music?"]){
        if (buttonIndex == 1){
            _playMusic = YES;
            if([player prepareToPlay]){
                [player play];
            }
        }
        else {
            _playMusic = NO;
        }
    }
}

- (BOOL)shouldPlayMusic{
    return _playMusic;
}


-(void)setVolume:(float)volume{
    player.volume = volume;
}

-(void)startNewMultiplayerGame{
    [player stop];
    TwoPlayerViewController *vc = [[TwoPlayerViewController alloc] init];
    vc.gc = _controller;
    vc.splash = self;
    [self.navigationController pushViewController:vc animated:NO];
}


@end
