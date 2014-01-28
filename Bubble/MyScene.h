//
//  MyScene.h
//  Bubble
//

//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AIBubble.h"
#import "UserBubble.h"
#import "ButtonBubble.h"

@interface MyScene : SKScene
{
    NSMutableArray *bubbles;
    NSMutableArray *directions;
    
    UserBubble *myBubble;
    ButtonBubble *upBubble;
    ButtonBubble *downBubble;
    ButtonBubble *leftBubble;
    ButtonBubble *rightBubble;

}

-(void) generateBubbles: (unsigned int)seed;

@end
