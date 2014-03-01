//
//  MyScene.h
//  Bubble
//

//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AIBubble.h"
#import "UserBubble.h"
#import "SecondViewController.h"
#import "JCJoystick.h"

@protocol ViewControllerDelegate <NSObject>

-(void)done:(NSString*)dataText;

@end

@interface MyScene : SKScene <ViewControllerDelegate>
{
//    id delegate;

    NSMutableArray *bubbles;
    NSMutableArray *multiplayerbubbles;
    NSMutableArray *directions;
    
    UserBubble *myBubble;
}

@property (nonatomic,assign) id <ViewControllerDelegate> delegate;
@property (strong, nonatomic) JCJoystick *joystick;

-(void) generateBubbles: (unsigned int)seed;

-(void) pause;

@end
NSString *globalData1;


