//
//  Bubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "PowerUp.h"

@implementation PowerUp

@synthesize radius = _radius;
@synthesize type = _type;
@synthesize idnum = _idnum;

-(id)init
{
    return [self initWithColor:[SKColor grayColor]];
}

-(id)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        _type = 'P';
        _radius = 5;
        _idnum = arc4random();
        //super.lineWidth = 1.0;
        //super.fillColor = color;
        //super.strokeColor = [SKColor whiteColor];
        //super.glowWidth = 0.0;
        super.zPosition = 11;
        [self updateArc];
    }
    
    return self;
}

-(id) initWithId:(int)initid andRadius:(float)radius andXcoord:(float)xcoord andYcoord:(float)ycoord
{
    self = [self initWithColor:[SKColor greenColor]];
    if (self)
    {
        _type = 'M';
        _idnum = initid;
        _radius=radius;
        CGPoint pos = CGPointMake(xcoord, ycoord);
        [super setPosition:pos];
    }
    return self;
}

-(void)updateRadius:(float)newradius
{
    _radius = newradius;
    self.zPosition = -1 * newradius;
}

-(double) getSpeed
{
    return 12*MIN(1 / sqrt(_radius), 2);
}

-(void) updateArc
{
    if (_radius < 1)
    {
    //    super.path = nil;
    }
    else
    {
        CGMutablePathRef myPath = CGPathCreateMutable();
        CGPathAddArc(myPath, NULL, 0,0, _radius, 0, M_PI*2, YES);
     //   super.path = myPath;
        
        //attempting to fix memory leak?
        CGPathRelease(myPath);
    }
}

-(bool) inside:(CGPoint)touch
{
    double distance = sqrt(pow(super.position.x - touch.x, 2) + pow(super.position.y - touch.y, 2));
    
    return (distance < _radius);
}

-(bool) collidesWith:(Bubble *)other
{
    return (sqrt(pow(super.position.x - other.position.x, 2) + pow(super.position.y - other.position.y, 2)) < _radius + other.radius);
}

-(NSString*) toString
{
    return [NSString stringWithFormat:@"%d %c %f %f %f  ", _idnum, _type, _radius, super.position.x, super.position.y];
}



@end
