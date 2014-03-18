//
//  UserBubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "UserBubble.h"

@implementation UserBubble

-(id) initWithId:(NSString*)initid andRadius:(float)radius andXcoord:(float)xcoord andYcoord:(float)ycoord
{
    self = [super initWithColor:[SKColor greenColor]];

        NSLog(@"aasddddffff");
        _type = 'M';
        idnum = initid;
        _radius=radius;
    super.radius = radius;
        //[self setRadius:radius];
        CGPoint pos = CGPointMake(xcoord, ycoord);
        [super setPosition:pos];
    return self;
}

-(id) init
{
    self = [super initWithColor:[SKColor redColor]];
    if (self)
    {
        idnum = [NSString stringWithFormat:@"%d",arc4random()];
        super.radius = 16;
        super.zPosition = 10;
        _type = 'U';
    }
    return self;
}

-(double) getSpeed
{
    return MIN(20 * (1 / sqrt(_radius)), 50);
}

-(void)updateRadius:(float)newradius
{
    _radius = newradius;
}

-(void) respawn:(CGPoint)pos
{
    _lives++;
    _radius = 16;
    super.position = pos;
    NSLog(@"%d Death(s)", _lives);
}

-(NSUInteger) lives{
    return _lives;
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
