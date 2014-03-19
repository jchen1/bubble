//
//  JCJoystick.h
//  Bubble
//
//  Created by Rolando Schneiderman on 2/20/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>

@interface JCJoystick : SKShapeNode

-(id)initWithControlRadius:(float)controlRadious
                baseRadius:(float)baseRadius
                 baseColor:(SKColor *)baseColor
            joystickRadius:(float)joystickRadius
             joystickColor:(SKColor *)joystickColor;
@property float x;
@property float y;
@property (nonatomic, strong) SKShapeNode *interior;
@property float angle;
@property (nonatomic,strong) UITouch *onlyTouch;
@property float baseRadius;
@property float controlRadius;
@property float joystickRadius;
@property float radiusSR2;
@property SKColor *baseColor;
@property SKColor *joystickColor;
@end
