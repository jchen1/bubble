//
//  MyScene.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];

        bubbles = [NSMutableArray array];
        myBubble = [[UserBubble alloc] init];
        myBubble.position = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame));
        
        [bubbles addObject:myBubble];
        [self addChild:myBubble];
        
        upBubble = [[ButtonBubble alloc] init],
        downBubble = [[ButtonBubble alloc] init],
        leftBubble = [[ButtonBubble alloc] init],
        rightBubble = [[ButtonBubble alloc] init];
        
        upBubble.position = CGPointMake(CGRectGetMaxX(self.frame) - 55,
                                 CGRectGetMinY(self.frame) + 85);
        downBubble.position = CGPointMake(CGRectGetMaxX(self.frame) - 55,
                                  CGRectGetMinY(self.frame) + 25);
        leftBubble.position = CGPointMake(CGRectGetMaxX(self.frame) - 85,
                                  CGRectGetMinY(self.frame) + 55);
        rightBubble.position = CGPointMake(CGRectGetMaxX(self.frame) - 25,
                                  CGRectGetMinY(self.frame) + 55);
        
        [self addChild:rightBubble];
        [self addChild:downBubble];
        [self addChild:leftBubble];
        [self addChild:upBubble];
        
        [self generateBubbles:rand()];

    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [upBubble setDown:false];
    [downBubble setDown:false];
    [leftBubble setDown:false];
    [rightBubble setDown:false];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([upBubble inside:location])
        {
            [upBubble setDown:true];
            [downBubble setDown:false];
            [leftBubble setDown:false];
            [rightBubble setDown:false];
        }
        else if ([downBubble inside:location])
        {
            [upBubble setDown:false];
            [downBubble setDown:true];
            [leftBubble setDown:false];
            [rightBubble setDown:false];
        }
        else if ([leftBubble inside:location])
        {
            [upBubble setDown:false];
            [downBubble setDown:false];
            [leftBubble setDown:true];
            [rightBubble setDown:false];
        }
        else if ([rightBubble inside:location])
        {
            [upBubble setDown:false];
            [downBubble setDown:false];
            [leftBubble setDown:false];
            [rightBubble setDown:true];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([upBubble inside:location])
        {
            [upBubble setDown:true];
        }
        else if ([downBubble inside:location])
        {
            [downBubble setDown:true];
        }
        else if ([leftBubble inside:location])
        {
            [leftBubble setDown:true];
        }
        else if ([rightBubble inside:location])
        {
            [rightBubble setDown:true];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    
    for (Bubble *b1 in bubbles) {
        for (Bubble *b2 in bubbles) {
            if (![b1 isEqual:b2] && [b1 collidesWith:b2]) {
                if (b1.radius < b2.radius) {
                    [b2 eat:b1];
                }
                else if (b1.radius > b2.radius) {
                    [b1 eat:b2];
                }
            }
        }
    }
    
    NSMutableIndexSet *removeIndices = [[NSMutableIndexSet alloc] init];
    
    if (myBubble.radius < 0.1)
    {
        [myBubble respawn:CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame))];
    }
    
    [myBubble updateArc];
    
    for (int i = 1; i < [bubbles count]; i++)
    {
        Bubble *b = [bubbles objectAtIndex:i];
        if (b.radius < 0.1)
        {
            [removeIndices addIndex:i];
            [b removeFromParent];
        }
        else
        {
            [b updatePosition];
            [b updateArc];
        }
    }
    
    if (upBubble.down) [myBubble updatePosition:0];
    if (downBubble.down) [myBubble updatePosition:1];
    if (leftBubble.down) [myBubble updatePosition:2];
    if (rightBubble.down) [myBubble updatePosition:3];
    
    [bubbles removeObjectsAtIndexes:removeIndices];
    
    if (MAX(0, (30 - [bubbles count])) > rand() % 100)
    {
        AIBubble *bubble = [[AIBubble alloc] init];
        bubble.position = CGPointMake(rand() % (int)CGRectGetMaxX(self.frame), rand() % (int)CGRectGetMaxY(self.frame));
        [bubbles addObject:bubble];
        [self addChild:bubble];
    }
    
}

-(void) generateBubbles:(unsigned int)seed
{
    srand(seed);
    int numBubbles = 10 + rand() % 20; //10 - 30 bubbles generated
    
    for (int i = 0; i < numBubbles; i++)
    {
        AIBubble *bubble = [[AIBubble alloc] init];
        bubble.position = CGPointMake(rand() % (int)CGRectGetMaxX(self.frame), rand() % (int)CGRectGetMaxY(self.frame));
        [bubbles addObject:bubble];
        [self addChild:bubble];
    }
}

@end
