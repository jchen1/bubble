//
//  MyScene.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerScene.h"

#define NUM_LIVES 3


@implementation SinglePlayerScene

int initial_count;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        lives = [NSMutableArray arrayWithCapacity:(NUM_LIVES - 1)];
        for (short i = 0; i < NUM_LIVES - 1; i++){
            [self addLife:i];
        }
    
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
        
        initial_count = 10 + arc4random_uniform(10);
        
        [bubbles addObject:myBubble];
        [self addChild:myBubble];
        [self generateBubbles:initial_count];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pause) name:@"single_pause" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unpause) name:@"single_unpause" object:nil];

    }
    return self;
}

-(void)addLife:(short)i{
    SKSpriteNode *life = [SKSpriteNode spriteNodeWithImageNamed:@"bubble_icon.png"];
    [life setScale:.020];
    life.position = CGPointMake(15*(i+1), CGRectGetMaxY(self.frame)-15);
    life.zPosition = MAXFLOAT;
    [self addChild: life];
    [lives addObject:life];
}

-(void)removeLife{
    SKSpriteNode *s = [lives lastObject];
    [s removeFromParent];
    [lives removeLastObject];
}

-(void)update:(CFTimeInterval)currentTime {
    
    if ([myBubble lives] >= NUM_LIVES){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!"
                                                        message:@"You ran out of lives."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.scene.view setPaused:YES];
    }
    
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
        [self removeLife];
    }
    
    [myBubble updateArc];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    for (int i = 1; i < [bubbles count]; i++)
    {
        Bubble *b = [bubbles objectAtIndex:i];
        if (b.radius < 0.1 || !CGRectContainsPoint(bounds,b.position) || [b radius] > 100.0)
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
    CGPoint pos = CGPointMake(myBubble.position.x+([myBubble getSpeed])*self.joystick.x, myBubble.position.y);
    if (CGRectContainsPoint(bounds,pos)){
        myBubble.position = pos;
    }
    pos = CGPointMake(myBubble.position.x, myBubble.position.y+([myBubble getSpeed])*self.joystick.y);
    if (CGRectContainsPoint(bounds,pos)){
        myBubble.position = pos;
    }

    [bubbles removeObjectsAtIndexes:removeIndices];
    
    double wut = arc4random_uniform([myBubble radius]);
    if ([bubbles count] < MAX(0.0,MIN(wut, initial_count - sqrt([myBubble radius]))))
    {
        [self spawnBubble];
    }
    
}

-(void) generateBubbles:(unsigned int)ic
{
    for (int i = 0; i < ic; i++)
    {
        [self spawnBubble];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Game Over!"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"single_gameover" object:nil];
    }
}

- (void)spawnBubble{
    AIBubble *bubble =[[AIBubble alloc] init];
    switch ([bubble preferredDirection]){
        case 0:
            bubble.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame), self.frame.origin.y);
            break;
        case 1:
            bubble.position = CGPointMake(self.frame.origin.x, arc4random() % (int)CGRectGetMaxY(self.frame));
            break;
        case 2:
            bubble.position = CGPointMake(arc4random() % (int)CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame) - 1);
            break;
        case 3:
            bubble.position = CGPointMake(CGRectGetMaxX(self.frame) - 1, arc4random() % (int)CGRectGetMaxY(self.frame));
            break;
        default: break;
    }
    [bubbles addObject:bubble];
    [self addChild:bubble];
}

@end