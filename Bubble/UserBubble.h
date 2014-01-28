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
-(void) respawn;

@end
