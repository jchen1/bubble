//
//  UserBubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "UserBubble.h"

@implementation UserBubble

@synthesize type = _type;
@synthesize deaths;
@synthesize idnum;


-(id) init
{
    self = [super initWithColor:[SKColor redColor]];
    if (self)
    {
        idnum = [NSString stringWithFormat:@"%d",arc4random()];
        self.deaths = 0;
        super.radius = 16;
        super.zPosition = -16;
        _type = 'U';
    }
    return self;
}

-(void) respawn:(CGPoint)pos
{
    deaths++;
    super.radius = 16;
    super.position = pos;
    self.zPosition = -16;
    NSLog(@"%d Death(s)", deaths);
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
