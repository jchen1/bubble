//
//  Bubble.h
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Bubble/Bubble.h"



@interface PowerUp : SKShapeNode

@property double radius;
@property char type;
@property int idnum;

-(id) initWithColor : (SKColor*) color;
-(id) initWithId:(int)initid andRadius:(float)radius andXcoord:(float)xcoord andYcoord:(float)ycoord;
-(bool) collidesWith:(Bubble *)other;
-(void)updateRadius:(float)newradius;
-(void) updateArc;
-(bool) inside: (CGPoint) touch;
-(double) getSpeed;
-(NSString*) toString;

@end
