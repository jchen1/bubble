//
//  SinglePlayerScene.h
//  Bubble
//

//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AIBubble.h"
#import "UserBubble.h"
#import "StalkerBubble.h"
#import "SplashViewController.h"
#import "JCJoystick.h"
#import "viewControllerDelegate.h"
#import "PowerUp.h"
#import "GameCenterController.h"

#define DILATE_PERCENT 0.99055
#define DILATE_TICKS 120
#define DILATE_RADIUS 50.0
#define DEATH_RADIUS 5.0
#define NUM_POWERUPS 3

@interface SinglePlayerScene : SKScene <UIAlertViewDelegate, viewControllerDelegate>
{
    int initial_count;
    int dilate_count;
    int shrink_count;
    int move_count;
    float aiBubbleScale;
    float userBubbleScale;
    AVAudioPlayer *player;
    AVAudioPlayer *player2;
    NSMutableArray *bubbles;
    NSMutableArray *prevBubbles;
    NSMutableArray *nextBubbles;
    NSMutableArray *directions;
    NSMutableArray *lives;
    NSMutableArray *powerups;
    JCJoystick *joystick;
    UserBubble *myBubble;
    NSURL *soundFileURL;
    NSString *soundFilePath;
}

-(void) pause;
-(void) unpause;
-(void) removeLife;
-(void) killAllBubbles;
-(void) dilate:(CGPoint)center;
-(void)clearDeadBubbles:(CGRect)bounds;
-(void) processEats;
-(AIBubble*) spawnBubble;

@property GameCenterController *gc;
@property id <viewControllerDelegate> delegate;
@property short numLives;
@property BOOL isHardcore;

@end


extern long long highscore;