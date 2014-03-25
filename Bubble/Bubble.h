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
@property int idnum;
@property double totalEaten;
@property float speedScale;
@property BOOL invulnerability;
@property SKColor *originalColor;

-(id) initWithColor : (SKColor*) color;
-(id) initWithId:(int)initid andRadius:(float)radius andPosition:(CGPoint)pos;
-(void)updateRadius:(float)newradius;
-(void) updateArc;
-(bool) inside: (CGPoint) touch;
-(bool) collidesWith: (Bubble*) other;
-(void) eat: (Bubble*) other;
-(void) eat: (Bubble*) other withMultiplier:(int)m;
-(double) getSpeed;
-(NSString*) toString;

@end
