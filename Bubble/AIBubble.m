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
        //super.radius = 3 + ((double)arc4random_uniform(69133742) / 9876248);
        super.radius = MAX(10.0,(double)(arc4random_uniform(100000) / 100000.0) * 40.0);
        preferredDirection = arc4random_uniform(4);
    }    
    
    return self;
}

//AIs are on diets
-(void) eat:(Bubble *)other
{
    return [super eat:other];
}

-(void) updatePosition
{
    CGPoint pos = super.position;
    switch (preferredDirection) {
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

-(short) preferredDirection{
    return preferredDirection;
}

@end
