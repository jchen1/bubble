//
//  TwoPlayerScene.h
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AIBubble.h"
#import "UserBubble.h"
#import "SplashViewController.h"
#import "JCJoystick.h"

@protocol ViewControllerDelegate <NSObject>

-(void)done:(NSString*)dataText;

@end

@interface TwoPlayerScene : SKScene <ViewControllerDelegate>
{
    //    id delegate;
    
    NSMutableArray *bubbles;
    NSMutableArray *directions;
    
    UserBubble *myBubble;
}

@property (nonatomic,assign) id <ViewControllerDelegate> delegate;
@property (strong, nonatomic) JCJoystick *joystick;

-(void) generateBubbles: (unsigned int)seed;

-(void) pause;

@end