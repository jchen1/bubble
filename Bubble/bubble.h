//
//  bubble.h
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface bubble : SKShapeNode
{
    int _radius;
}
-(void) updateArc;
-(void) setRadius: (int) radius;
-(int)radius;
-(void) grow;


@end
