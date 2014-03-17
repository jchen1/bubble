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
        super.radius = (double)(arc4random_uniform(1000) / 1000.0) * 20;
        short preferredDirection = arc4random_uniform(4);
        _directions = makeDirections(preferredDirection);
    }    
    
    return self;
}

-(id) initWithSizeAsSeed: (double) size{
    self = [super initWithColor:[SKColor blueColor]];
    if (self)
    {
        _type = 'A';
        super.zPosition = 9;
        //super.radius = 3 + ((double)arc4random_uniform(69133742) / 9876248);
        super.radius = MAX(5.0,(double)(arc4random_uniform(500) / 1000.0) * size);
        short preferredDirection = arc4random_uniform(4);
        _directions = makeDirections(preferredDirection);
        NSLog(@"%d", (int)preferredDirection);
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
    NSNumber *dir = [_directions objectAtIndex:arc4random_uniform(50)];
    int direction = [dir intValue];
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

NSMutableArray* makeDirections(short pd){
    NSMutableArray *dir = [NSMutableArray arrayWithCapacity:100];
    short i;
    for (i = 0; i < 5; i++){
        //5% chance to go opposite of preferred
        [dir addObject:[NSNumber numberWithInt:((pd + 2)%4)]];
    }
    for (i = 0; i < 10; i++){
        //10% chance to perpendicular directions
        [dir addObject:[NSNumber numberWithInt:((pd + 1)%4)]];
        [dir addObject:[NSNumber numberWithInt:((pd + 3)%4)]];
    }
    for (i = 0; i < 75; i++){
        //50% chance of going preferred direction
        [dir addObject:[NSNumber numberWithInt:pd]];
    }
    return dir;
}

@end
