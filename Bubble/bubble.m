//
//  bubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "bubble.h"

@implementation bubble

-(id)init
{
    self = [super init];
    if (self) {
        _radius = 15;
        super.lineWidth = 1.0;
        super.fillColor = [SKColor blueColor];
        super.strokeColor = [SKColor whiteColor];
        super.glowWidth = 0.0;
        [self updateArc];
    }
    
    return self;
}

-(void) updateArc
{
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0,0, _radius, 0, M_PI*2, YES);
    super.path = myPath;
}

-(void) setRadius: (int) radius
{
    _radius = radius;
}

-(void) grow
{
    _radius++;
    [self updateArc];
}

-(int)radius
{
    return _radius;
}

@end
