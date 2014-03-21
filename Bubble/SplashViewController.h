//
//  SplashViewController.h
//  Bubble
//
//  Created by Rolando Schneiderman on 1/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//
#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "viewControllerDelegate.h"

// Preferred method for testing for Game Center
BOOL isGameCenterAvailable();


@interface SplashViewController : UIViewController<viewControllerDelegate, GKGameCenterControllerDelegate, GKSessionDelegate> {
    UIButton *optionsButton;
    UIButton *singlePlayerButton;
    UIButton *twoPlayerButton;
    UIImageView *bubbleIcon;
}


@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString *leaderboardIdentifier;


// currentPlayerID is the value of the playerID last time GameKit authenticated.
@property (retain,readwrite) NSString * currentPlayerID;

// isGameCenterAuthenticationComplete is set after authentication, and authenticateWithCompletionHandler's completionHandler block has been run. It is unset when the applicaiton is backgrounded.
@property (readwrite, getter=isGameCenterAuthenticationComplete) BOOL gameCenterAuthenticationComplete;

 -(void)authenticateLocalPlayer;
 -(void)reportScore;
-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard;


@end

