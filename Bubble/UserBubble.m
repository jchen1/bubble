//
//  UserBubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "UserBubble.h"

@implementation UserBubble

-(id) init
{
    self = [super initWithColor:[SKColor redColor]];
    super.radius = 16;
    super.zPosition = 10;
    return self;
}

-(void) updatePosition
{

}

-(void) respawn
{
    _lives++;
    _radius = 16;
}

-(void)updatePosition:(int)direction
{
    CGPoint pos = super.position;
    switch (direction) {
        case 0: //up
            pos.y++;
            break;
        case 1: //down
            pos.y--;
            break;
        case 2: //left
            pos.x--;
            break;
        case 3: //right
            pos.x++;
            break;
        default:
            break;  //wut
    }
    
    [super setPosition:pos];
}

@end
