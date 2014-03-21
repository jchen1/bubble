//
//  AIBubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "AIBubble.h"

double normalDistribution(double avg, double sigma){
    double u =(double)(arc4random() %100000 + 1)/100000;
    double v =(double)(arc4random() %100000 + 1)/100000;
    double x = sqrt(-2*log(u))*cos(2*M_PI*v);
    return x * sigma + avg;
}


@implementation AIBubble

@synthesize type = _type;
@synthesize preferredDirection = pd;

-(id) init
{
    if (self = [super initWithColor:[SKColor blueColor]])
    {
        _type = 'A';
        super.radius = MAX(5.0,(double)(arc4random_uniform(100000) / 100000.0) * 60.0);
        super.zPosition = -1 * super.radius;
        pd = arc4random_uniform(4);
    }    
    
    return self;
}

-(id)initFromRadius:(double)radius{
    if (self = [super initWithColor:[SKColor blueColor]]){
        _type = 'A';
        super.radius = MIN(80.0, MAX(3.0, normalDistribution(radius, 10)));
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
