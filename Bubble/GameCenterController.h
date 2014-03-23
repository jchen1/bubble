//
//  GameCenterController.h
//  Bubble
//
//  Created by Stephen Greco on 3/22/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "viewControllerDelegate.h"

@interface GameCenterController : NSObject <GKGameCenterControllerDelegate, GKSessionDelegate, GKLocalPlayerListener,
GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKLocalPlayerListener>{

}

@property UINavigationController* controller;
@property id<viewControllerDelegate> splash;
@property id<viewControllerDelegate> currentGameView;
@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@property (retain,readwrite) NSString * currentPlayerID;
@property (readwrite, getter=isGameCenterAuthenticationComplete) BOOL gameCenterAuthenticationComplete;

-(void)authenticateLocalPlayer;
-(void)reportScore;
-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard;
-(void)sendBubbleData:(NSData*)data;
-(void)sendScore:(long long)score;
-(void)sendAchievement:(NSString*)ident;
-(void)findGame;
-(void)disconnect;


@end
