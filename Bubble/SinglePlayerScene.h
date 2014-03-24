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
#import "SplashViewController.h"
#import "JCJoystick.h"
#import "viewControllerDelegate.h"
#import "PowerUp.h"
#import "GameCenterController.h"

#define NUM_LIVES 1
#define DILATE_PERCENT 0.99055
#define DILATE_TICKS 120
#define DILATE_RADIUS 50.0
#define DEATH_RADIUS 5.0
#define NUM_POWERUPS 3

@interface SinglePlayerScene : SKScene <UIAlertViewDelegate>
{
    int initial_count;
    int dilate_count;
    int shrink_count;
    float aiBubbleScale;
    float userBubbleScale;
    AVAudioPlayer *player;
    NSMutableArray *bubbles;
    NSMutableArray *directions;
    NSMutableArray *lives;
    NSMutableArray *powerups;
    JCJoystick *joystick;
    UserBubble *myBubble;
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

@end


extern long long highscore;