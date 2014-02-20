//
//  JCJoystick.h
//  Bubble
//
//  Created by Rolando Schneiderman on 2/20/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//
///SEE SECONDVIEWCONTROLLER.M TO GET STARTED
///

#import <SpriteKit/SpriteKit.h>

@interface JCJoystick : SKShapeNode
{
    
    
}
-(id)initWithControlRadius:(float)controlRadious
                baseRadius:(float)baseRadius
                 baseColor:(SKColor *)baseColor
            joystickRadius:(float)joystickRadius
             joystickColor:(SKColor *)joystickColor;
@property float x;
@property float y;
@end
