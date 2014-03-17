//
//  UserBubble.h
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "Bubble.h"

@interface UserBubble : Bubble
{
    int _lives;
}

-(void) updatePosition: (int)direction;
-(void) respawn: (CGPoint) pos;
-(double) getSpeed;
-(NSUInteger) lives;
-(void)updateRadius:(float)newradius;
-(id) initWithId:(NSString*)initid andRadius:(float)radius andXcoord:(float)xcoord andYcoord:(float)ycoord;

@end
