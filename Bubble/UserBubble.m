//
//  UserBubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "UserBubble.h"

@implementation UserBubble

-(id) initWithArgs: (NSString*) initid radius:(float) radius xcoord:(float) xcoord ycoord:(float) ycoord
{
    self = [super initWithColor:[SKColor blueColor]];
    if (self)
    {
        _type = 'U';
        idnum = initid;
        [self setRadius:radius];
        CGPoint pos = CGPointMake(xcoord, ycoord);
        [super setPosition:pos];
    }
    return self;
}

-(id) init
{
    self = [super initWithColor:[SKColor redColor]];
    if (self)
    {
        //idnum = [NSString stringWithFormat:@"%d",rand()];
        idnum = @"8";
        super.radius = 10;
        super.zPosition = 10;
        _type = 'U';
    }
    return self;
}

-(double) getSpeed
{
    return MIN(30 * (1 / sqrt(_radius)), 100);
}

-(void) updatePosition
{

}

-(void) respawn:(CGPoint)pos
{
    _lives++;
    _radius = 16;
    super.position = pos;
}


-(void)updatePosition:(int)direction
{
    CGPoint pos = super.position;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    switch (direction) {
        case 0: //up
            pos.y+= [self getSpeed];
            break;
        case 1: //down
            pos.y-= [self getSpeed];
            break;
        case 2: //left
            pos.x-= [self getSpeed];
            break;
        case 3: //right
            pos.x+= [self getSpeed];
            break;
        default:
            break;  //wut wut in the but
    }
    if (CGRectContainsPoint(bounds,pos)){
        [super setPosition:pos];
    }
}

@end
