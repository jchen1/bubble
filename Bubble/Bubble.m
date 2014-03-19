//
//  bubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

-(id)init
{
    return [self initWithColor:[SKColor grayColor]];
}

-(id)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        _radius = 5;
        _type = 'B';
        super.lineWidth = 1.0;
        super.fillColor = color;
        super.strokeColor = [SKColor whiteColor];
        super.glowWidth = 0.0;
        super.zPosition = 11;
        [self updateArc];
    }
    
    return self;
}

-(id) initWithId:(NSString*)initid andRadius:(float)radius andXcoord:(float)xcoord andYcoord:(float)ycoord
{
    self = [self initWithColor:[SKColor greenColor]];
    if (self)
    {
        _type = 'M';
        idnum = initid;
        _radius=radius;
        //[self setRadius:radius];
        CGPoint pos = CGPointMake(xcoord, ycoord);
        [super setPosition:pos];
    }
    return self;
}

-(void)updateRadius:(float)newradius
{
    _radius = newradius;
}

-(void) updateArc
{
    if (_radius < 1)
    {
        super.path = nil;
    }
    else
    {
        CGMutablePathRef myPath = CGPathCreateMutable();
        CGPathAddArc(myPath, NULL, 0,0, _radius, 0, M_PI*2, YES);
        super.path = myPath;
    }
}

-(void) setRadius: (double) radius
{
    _radius = radius;
}

-(double)radius
{
    return _radius;
}

-(NSString*)idnum
{
    return idnum;
}

-(void) eat:(Bubble *)other
{
    if (other.radius > _radius)
    {
        return;
    }
    double area1 = _radius * _radius * M_PI, area2 = other.radius * other.radius * M_PI;
    area1 += MIN(area2, 20.0) / 2.0;
    area2 -= MIN(area2, 20.0);
    
    _radius = sqrt(area1 / M_PI);
    self.zPosition = -1 * _radius;
    other.radius = sqrt(area2 / M_PI);
    other.zPosition = -1 * other.radius;
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
    return [NSString stringWithFormat:@"%@ %c %f %f %f  ", idnum, _type, _radius, super.position.x, super.position.y];
}

-(double) getSpeed
{
    return MIN((5 / sqrt(_radius)), 10);
}

/*
 * Don't do anything, because fuck that shit.
 */
-(void)updatePosition
{
    
}

@end
