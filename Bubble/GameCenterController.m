//
//  GameCenterController.m
//  Bubble
//
//  Created by Stephen Greco on 3/22/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "GameCenterController.h"
#import "SplashViewController.h"
#import "TwoPlayerViewController.h"

@implementation GameCenterController{
    GKMatchmaker *matchmaker;
    GKMatch *myMatch;
    NSMutableArray *playersToInvite;
}

@synthesize controller = controller, splash = splash, currentGameView = game;

- (id) init{
    if (self = [super init]){
        [self authenticateLocalPlayer];
    }
    return self;
}

-(void)sendScore:(long long)score{
    [self reportScore:score forLeaderboardID:@"1"];
}

-(void)sendAchievement:(NSString *)achievementIdentifier{
    [self reportAchievementIdentifier:achievementIdentifier percentComplete:100];
}

- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController.presentingViewController dismissViewControllerAnimated:YES completion:^(void){}];
}

-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [controller presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                [[GKLocalPlayer localPlayer] registerListener:self];
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
                NSMutableArray *loadedAchievements = [[NSMutableArray alloc] init];
                [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
                 {
                     if(error != NULL) { NSLog(@"%@", [error description]); }
                     [loadedAchievements addObjectsFromArray:scores];
                 }];
                
                for (NSString*scores in loadedAchievements) {
                    NSLog (@"Your Array elements are = %@", scores);
                }
                
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

-(void)resetAchievements{
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)invite{
    [[GKMatchmaker sharedMatchmaker] matchForInvite:invite completionHandler:^(GKMatch *match, NSError *error) {
        myMatch = match;
        match.delegate = self;
        [splash startNewMultiplayerGame];
    }];
}

- (void)player:(GKPlayer *)player didRequestMatchWithPlayers:(NSArray *)playerIDsToInvite{
    
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = [self leaderboardIdentifier];
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [controller presentViewController:gcViewController animated:YES completion:nil];
}

-(void)findGame{
    GKMatchRequest *matchrequest = [[GKMatchRequest alloc] init];
    matchrequest.maxPlayers = 2;
    
    GKMatchmakerViewController *mmcontroller = [[GKMatchmakerViewController alloc] initWithMatchRequest:matchrequest];
    mmcontroller.matchmakerDelegate = self;
    [controller presentViewController:mmcontroller animated:YES completion:nil];
    
    matchmaker = [GKMatchmaker sharedMatchmaker];
    [matchmaker
     findMatchForRequest:matchrequest
     withCompletionHandler:^(GKMatch *match, NSError *error) {
         if (error) {
             NSLog(@"%@", [error description]);
         }
         else {
             [self newMatch:match];
         }
     }];
}

- (void)startLookingForPlayers
{
    [matchmaker startBrowsingForNearbyPlayersWithReachableHandler:^(NSString *playerID, BOOL reachable) {
        [playersToInvite addObject:playerID];
    }];
}

- (void)stopLookingForPlayers
{
    [[GKMatchmaker sharedMatchmaker] stopBrowsingForNearbyPlayers];
}


- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController
                    didFindMatch:(GKMatch *)match
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [self newMatch:match];
}

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [controller popViewControllerAnimated:NO];
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [controller popViewControllerAnimated:NO];
}

- (void)match:(GKMatch *)match didFailWithError:(NSError *)error{
    NSLog(@"%@", [error description]);
    [match disconnect];
}

- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state{
    switch (state){
        case GKPlayerStateConnected: break;
        case GKPlayerStateUnknown: break;
        case GKPlayerStateDisconnected:
            /*[[NSNotificationCenter defaultCenter] postNotificationName:@"gameQuit" object:nil];
             NSString *beatMessage = [NSString stringWithFormat:@"You beat %@.", playerID];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
             message:beatMessage
             delegate:self
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil];
             [alert show];*/
            break;
    }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID{
    [game handleReceivedData:data];
}

- (BOOL)match:(GKMatch *)match shouldReinvitePlayer:(NSString *)playerID{
    return NO;
}

- (void)newMatch:(GKMatch*)match{
    myMatch = match;
    match.delegate = self;
    [splash startNewMultiplayerGame];
}

- (void)sendBubbleData:(NSData *)data{
    NSError *error;
    [myMatch sendDataToAllPlayers:data withDataMode:GKSendDataUnreliable error:&error];
    NSLog(@"sent bubble data");
}

- (void) disconnect{
    [myMatch disconnect];
}

@end
