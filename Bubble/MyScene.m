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
        
        upBubble.zPosition = 11;
        downBubble.zPosition = 11;
        leftBubble.zPosition = 11;
        rightBubble.zPosition = 11;
        
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
        
        bool done = false, inside = false;
        
        if ([upBubble inside:location])
        {
            [upBubble setDown:true];
            done = true;
        }
        else if ([downBubble inside:location])
        {
            [downBubble setDown:true];
            done = true;
        }
        else if ([leftBubble inside:location])
        {
            [leftBubble setDown:true];
            done = true;
        }
        else if ([rightBubble inside:location])
        {
            [rightBubble setDown:true];
            done = true;
        }
        
        
        /*
        for (Bubble *b in bubbles) {
            if ([b inside:location]) {
                [b setRadius:(b.radius + 1)];
                inside = true;
            }
        }*/
        
        if (!inside && !done) {
            AIBubble *b = [[AIBubble alloc] init];
            b.position = location;
            
            [bubbles addObject:b];
            [self addChild:b];
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
        [myBubble respawn];
        myBubble.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame));
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
    
}

@end
