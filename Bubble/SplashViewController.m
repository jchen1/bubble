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
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <GameKit/GameKit.h>

#ifdef TWOPLAYER
#import "TwoPlayerViewController.h"
#endif

@implementation SplashViewController
{
    AVAudioPlayer*player;
}

@synthesize currentPlayerID,
            gameCenterAuthenticationComplete;

-(void)sendScore:(long long)score{
    [self reportScore:score forLeaderboardID:@"1"];
}

-(void)sendAchievement:(NSString *)achievementIdentifier{
    [self reportAchievementIdentifier:achievementIdentifier percentComplete:100];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *loadedAchievements = [[NSMutableArray alloc] init];
    
    [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
     {
         if(error != NULL) { /* error handling */ }
         [loadedAchievements addObjectsFromArray:scores];
         // work with achievement here, store it in your cache or smith
     }];
    
    for (NSString*scores in loadedAchievements) {
        NSLog (@"Your Array elements are = %@", scores);
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pauseMusic) name:@"splash_pause" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeMusic) name:@"splash_resume" object:nil];
    [self authenticateLocalPlayer];
    [self setUpUI];
    
    //set the value of global variable highscore
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    highscore = [[defaults valueForKey:@"singleHighScore"] longValue];
}

- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController.presentingViewController dismissViewControllerAnimated:YES completion:^(void){}];
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
    [self showLeaderboardAndAchievements:true];
}

- (void) setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *singlePlayerButtonBackground = [UIImage imageNamed:@"1p_button.png"];
    UIImage *twoPlayerButtonBackground = [UIImage imageNamed:@"2p_button.png"];
    UIImage *optionsButtonBackground = [UIImage imageNamed:@"options_button.png"];
    UIImage *gameCenterButtonBackground = [UIImage imageNamed:@"game_center_logo.png"];
    UIImage *twitterButtonBackground = [UIImage imageNamed:@"twitter_logo.png"];
    UIImage *bubbleIconImage = [UIImage imageNamed:@"bubble_icon_title.png"];
    
    bubbleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100,
                                                               50.0, 200.0, 200.0)];
    bubbleIcon.image = bubbleIconImage;
    [self.view addSubview:bubbleIcon];
    
    singlePlayerButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [singlePlayerButton setFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100,
                                            self.view.bounds.size.height - 220.0, 200.0, 50.0)];
    [singlePlayerButton setBackgroundImage:singlePlayerButtonBackground forState:UIControlStateNormal];
    [singlePlayerButton addTarget:self action:@selector(gameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:singlePlayerButton];
    
    twoPlayerButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [twoPlayerButton setFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100,
                                         self.view.bounds.size.height - 160.0, 200.0, 50.0)];
    [twoPlayerButton setBackgroundImage:twoPlayerButtonBackground forState:UIControlStateNormal];
    [twoPlayerButton addTarget:self action:@selector(multiGameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoPlayerButton];

    optionsButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [optionsButton setFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100,
                                       self.view.bounds.size.height - 100.0, 200.0, 50.0)];
    [optionsButton setBackgroundImage:optionsButtonBackground forState:UIControlStateNormal];
    [optionsButton addTarget:self action:@selector(optionsView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:optionsButton];
    
    
    gameCenterButton =  [UIButton buttonWithType:UIButtonTypeSystem];
    [gameCenterButton setFrame:CGRectMake(5.0, self.view.bounds.size.height - 25.0, 20.0, 20.0)];
    [gameCenterButton setBackgroundImage:gameCenterButtonBackground forState:UIControlStateNormal];
    [gameCenterButton addTarget:self action:@selector(gameCenterView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gameCenterButton];
    
    twitterButton =  [UIButton buttonWithType:UIButtonTypeSystem];
    [twitterButton setFrame:CGRectMake(30.0, self.view.bounds.size.height - 25.0, 20.0, 20.0)];
    [twitterButton setBackgroundImage:twitterButtonBackground forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(twitterView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitterButton];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //infinite loop
    
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

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category

{
    GKScore* scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:category];
    
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"error: %@", error);
        }
    }];
}

-(void)reportScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    score.value = [[defaults valueForKey:@"singleHighScore"] longValue];
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (IBAction)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float) percent {
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    achievement.showsCompletionBanner = YES;
    if (achievement)
    {
        achievement.percentComplete = percent;
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error in reporting achievements: %@", error);
            }
        }];
    }
}
-(void)reportAchievement{
    GKAchievement *achieve = [[GKAchievement alloc] initWithIdentifier:@"1"];
    [GKAchievement reportAchievements:@[achieve] withCompletionHandler:^(NSError *error) {
        if(error!=nil)
        {NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
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
}

-(void)resetAchievements{
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

@end
