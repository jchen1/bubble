//
//  bubble.h
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bubble : SKShapeNode
{
    double _radius;
    char _type;
}
-(id) initWithColor : (SKColor*) color;
-(void) updateArc;
-(void) setRadius: (double) radius;
-(double) radius;
-(void) updatePosition;
-(bool) inside: (CGPoint) touch;
-(bool) collidesWith: (Bubble*) other;
-(void) eat: (Bubble*) other;


@end
