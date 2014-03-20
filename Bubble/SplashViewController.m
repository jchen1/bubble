//
//  SplashViewController.m
//  Bubble
//
//  Created by Jeff Chen on 9/27/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//


#import "SplashViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "SinglePlayerViewController.h"
#import "SettingsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <GameKit/GameKit.h>

#define TWOPLAYER

#ifdef TWOPLAYER
#import "TwoPlayerViewController.h"
#endif

@implementation SplashViewController
{
    AVAudioPlayer*player;
    
}

#pragma mark -
#pragma mark Game Center Support

@synthesize currentPlayerID,
            gameCenterAuthenticationComplete;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [self setUpUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pauseMusic) name:@"splash_pause" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeMusic) name:@"splash_resume" object:nil];
    [self authenticateLocalPlayer];
    //[self showLeaderboardAndAchievements:true];

}



- (IBAction)pauseMusic
{
    [player stop];
}

-(IBAction)resumeMusic
{
    player.currentTime = 0;
    [player play];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gameView {
    SinglePlayerViewController *gameView = [[SinglePlayerViewController alloc] init];
    [player stop];
    gameView.splash = self;
    [self.navigationController pushViewController:gameView animated:NO];
}

- (IBAction)multiGameView {
    [player stop];
#ifndef TWOPLAYER    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon!"
                                                    message:@"This feature is still in development."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#else
    TwoPlayerViewController *gameView = [[TwoPlayerViewController alloc] init];
    [self.navigationController pushViewController:gameView animated:NO];
#endif
}

- (IBAction)optionsView {
    SettingsViewController *settingsView = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsView animated:NO];
}

- (void) setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *singlePlayerButtonBackground = [UIImage imageNamed:@"1p_button.png"];
    UIImage *twoPlayerButtonBackground = [UIImage imageNamed:@"2p_button.png"];
    UIImage *optionsButtonBackground = [UIImage imageNamed:@"options_button.png"];
    UIImage *bubbleIconImage = [UIImage imageNamed:@"bubble_icon_title.png"];
    
    bubbleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, 50.0, 200.0, 200.0)];
    bubbleIcon.image = bubbleIconImage;
    [self.view addSubview:bubbleIcon];
    
    singlePlayerButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [singlePlayerButton setFrame:CGRectMake(60.0, self.view.bounds.size.height - 220.0, 200.0, 50.0)];
    [singlePlayerButton setBackgroundImage:singlePlayerButtonBackground forState:UIControlStateNormal];
    [singlePlayerButton addTarget:self action:@selector(gameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:singlePlayerButton];
    
    twoPlayerButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [twoPlayerButton setFrame:CGRectMake(60.0, self.view.bounds.size.height - 160.0, 200.0, 50.0)];
    [twoPlayerButton setBackgroundImage:twoPlayerButtonBackground forState:UIControlStateNormal];
    [twoPlayerButton addTarget:self action:@selector(multiGameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoPlayerButton];

    optionsButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [optionsButton setFrame:CGRectMake(60.0, self.view.bounds.size.height - 100.0, 200.0, 50.0)];
    [optionsButton setBackgroundImage:optionsButtonBackground forState:UIControlStateNormal];
    [optionsButton addTarget:self action:@selector(optionsView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:optionsButton];
    
    //background audio
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite loop
    if([player prepareToPlay])
    {
        [player play];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}

-(void)reportScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    //score.value = _score;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    NSLog(@"leaderboard");
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
    NSLog(@"asdf");
}

@end
