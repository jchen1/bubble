//
//  AIBubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "AIBubble.h"

@implementation AIBubble

-(id) init
{
    self = [super initWithColor:[SKColor blueColor]];
    if (self)
    {
        _type = 'A';
        super.zPosition = 9;
        super.radius = 5 + ((double)arc4random_uniform(69133742) / 6913374);
    }
    
    return self;
}

//AIs are on diets
-(void) eat:(Bubble *)other
{
    
}

-(void) updatePosition
{
    CGPoint pos = super.position;
    int direction = arc4random_uniform(4);
    switch (direction) {
        case 0: //up
            pos.y+= [super getSpeed];
            break;
        case 1: //down
            pos.y-= [super getSpeed];
            break;
        case 2: //left
            pos.x-= [super getSpeed];
            break;
        case 3: //right
            pos.x+= [super getSpeed];
            break;
        default:
            break;  //wut
    }
    
    [super setPosition:pos];
}

@end
