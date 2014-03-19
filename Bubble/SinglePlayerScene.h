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


@interface SinglePlayerScene : SKScene <UIAlertViewDelegate>
{
    //    id delegate;
    
    NSMutableArray *bubbles;
    NSMutableArray *directions;
    NSMutableArray *lives;
    
    UserBubble *myBubble;
}

@property (strong, nonatomic) JCJoystick *joystick;


-(void) generateBubbles: (unsigned int)seed;

-(void) pause;

@end


