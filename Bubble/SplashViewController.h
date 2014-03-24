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
#import <Social/Social.h>
#import <MediaPlayer/MediaPlayer.h>
#import "viewControllerDelegate.h"
#import "GameCenterController.h"

//#define TWOPLAYER

// Preferred method for testing for Game Center

@protocol splashViewControllerDelegate <NSObject>

-(void)getScore:(long long)score;
-(void)getAchievement:(NSString*)achievementIdentifier;

@end


@interface SplashViewController : UIViewController<viewControllerDelegate> {
    UIButton *optionsButton;
    UIButton *singlePlayerButton;
    UIButton *twoPlayerButton;
    UIButton *twitterButton;
    UIButton *gameCenterButton;
    UIImageView *bubbleIcon;
}

@property BOOL playMusic;
@property GameCenterController *gcController;
@end

long long highscore;
