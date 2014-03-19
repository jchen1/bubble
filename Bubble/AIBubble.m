//
//  AIBubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "AIBubble.h"

@implementation AIBubble

@synthesize type = _type;
@synthesize preferredDirection = pd;

-(id) init
{
    self = [super initWithColor:[SKColor blueColor]];
    if (self)
    {
        _type = 'A';
        super.radius = MAX(5.0,(double)(arc4random_uniform(100000) / 100000.0) * 40.0);
        super.zPosition = -1 * super.radius;
        pd = arc4random_uniform(4);
    }    
    
    return self;
}

-(void) updatePosition
{
    CGPoint pos = super.position;
    switch (pd) {
        case 0: //up
            pos.y+= [super getSpeed];
            break;
        case 1: //right
            pos.x+= [super getSpeed];
            break;
        case 2: //down
            pos.y-= [super getSpeed];
            break;
        case 3: //left
            pos.x-= [super getSpeed];
            break;
        default:
            break;  //wut
    }
    
    [super setPosition:pos];
}

@end
