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

-(id) initWithArgs: (NSString*) initid radius:(float) radius xcoord:(float) xcoord ycoord:(float) ycoord;

@end
