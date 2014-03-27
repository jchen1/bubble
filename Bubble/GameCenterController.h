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

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard;
-(void)sendBubbleData:(NSData*)data;
-(void)sendAchievement:(NSString*)ident;
-(void)findGame;
-(void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float) percent;
-(void)disconnect;
-(void)reportScore:(int64_t)score forLeaderboardID:(NSString*)board;
@property (readonly, nonatomic) NSString *storedFilename;
@property (readonly, nonatomic) NSMutableDictionary *storedAchievements;

// resubmit any local instances of GKAchievement that was stored on a failed submission.
- (void)resubmitStoredAchievements;

// write all stored achievements for future resubmission
- (void)writeStoredAchievements;

// load stored achievements that haven't been submitted to the server
- (void)loadStoredAchievements;

// store an achievement for future resubmit
- (void)storeAchievement:(GKAchievement *)achievement ;

// submit an achievement
- (void)submitAchievement:(GKAchievement *)achievement ;

// reset achievements
- (void)resetAchievements;


@end
