//
//  SinglePlayerScene.h
//  Bubble
//

//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AIBubble.h"
#import "UserBubble.h"
#import "SplashViewController.h"
#import "JCJoystick.h"
#import "viewControllerDelegate.h"

@interface SinglePlayerScene : SKScene <UIAlertViewDelegate>
{
    int initial_count;
    int dilate_count;
    int shrink_count;
    NSMutableArray *bubbles;
    NSMutableArray *directions;
    NSMutableArray *lives;
    JCJoystick *joystick;
    UserBubble *myBubble;
}

-(void) pause;
-(void) unpause;

@property id <viewControllerDelegate> delegate;

@end


extern long long highscore;