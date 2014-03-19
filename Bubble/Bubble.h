//
//  Bubble.h
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bubble : SKShapeNode

@property double radius;
@property char type;
@property (strong) NSString* idnum;

-(id) initWithColor : (SKColor*) color;
-(id) initWithId:(NSString*)initid andRadius:(float)radius andXcoord:(float)xcoord andYcoord:(float)ycoord;
-(void)updateRadius:(float)newradius;
-(void) updateArc;
-(bool) inside: (CGPoint) touch;
-(bool) collidesWith: (Bubble*) other;
-(void) eat: (Bubble*) other;
-(double) getSpeed;
-(NSString*) toString;

@end
