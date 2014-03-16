//
//  MyScene.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerScene.h"


@implementation SinglePlayerScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.joystick = [[JCJoystick alloc] initWithControlRadius:40
                                                baseRadius:45 baseColor:[SKColor grayColor]
                                                joystickRadius:25 joystickColor:[SKColor whiteColor]];
        [self.joystick setPosition:CGPointMake(160,70)];
        [self addChild:self.joystick];
        _joystick.alpha = .5;
        _joystick.zPosition= 120;

        self.backgroundColor = [SKColor blackColor];

        bubbles = [NSMutableArray array];

        myBubble = [[UserBubble alloc] init];
        myBubble.position = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame));
        
        
        [bubbles addObject:myBubble];
        [self addChild:myBubble];
        [self generateBubbles:rand()];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pause) name:@"single_pause" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unpause) name:@"single_unpause" object:nil];

    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {

    
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
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGPoint pos = CGPointMake(myBubble.position.x+(10)*self.joystick.x, myBubble.position.y);
    if (CGRectContainsPoint(bounds,pos)){
        myBubble.position = pos;
    }
    pos = CGPointMake(myBubble.position.x, myBubble.position.y+(10)*self.joystick.y);
    if (CGRectContainsPoint(bounds,pos)){
        myBubble.position = pos;
    }

    [bubbles removeObjectsAtIndexes:removeIndices];
    
    if (MAX(0, (int)(30 - (int)[bubbles count])) > arc4random() % 100)
    {
        AIBubble *bubble = [[AIBubble alloc] init];
        bubble.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame),
                                      arc4random() % (int)CGRectGetMaxY(self.frame));
        [bubbles addObject:bubble];
        [self addChild:bubble];
    }
    
}

-(void) generateBubbles:(unsigned int)seed
{
    srand(seed);
    int numBubbles = 10 + arc4random() % 20; //10 - 30 bubbles generated
    
    for (int i = 0; i < numBubbles; i++)
    {
        AIBubble *bubble = [[AIBubble alloc] init];
        bubble.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame),
                                      arc4random() % (int)CGRectGetMaxY(self.frame));
        [bubbles addObject:bubble];
        [self addChild:bubble];
    }
}

-(void) pause
{
    [self.scene.view setPaused:YES];
}

-(void) unpause
{
    [self.scene.view setPaused:NO];
}

@end
