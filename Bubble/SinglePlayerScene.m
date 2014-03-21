//
//  SinglePlayerScene.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerScene.h"
#import <AVFoundation/AVFoundation.h>

#define NUM_LIVES 1
#define DILATE_PERCENT 0.99055
#define DILATE_TICKS 120


@implementation SinglePlayerScene
{
    AVAudioPlayer*player;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor blackColor];
        
        lives = [NSMutableArray arrayWithCapacity:(NUM_LIVES - 1)];
        for (short i = 0; i < NUM_LIVES - 1; i++){
            [self addLife:i];
        }
        
        joystick = [[JCJoystick alloc] initWithControlRadius:40
                                                  baseRadius:45 baseColor:[SKColor grayColor]
                                              joystickRadius:25 joystickColor:[SKColor whiteColor]];
        [joystick setPosition:CGPointMake(CGRectGetMidX(self.frame),70)];
        [self addChild:joystick];
        joystick.alpha = .5;
        joystick.zPosition= 120;
        
        bubbles = [NSMutableArray array];
        
        myBubble = [[UserBubble alloc] init];
        myBubble.position = CGPointMake(CGRectGetMidX(self.frame),
                                        CGRectGetMidY(self.frame));
        
        initial_count = 5 + arc4random_uniform(5);
        dilate_count = 0;
        shrink_count = 0;
        
        [bubbles addObject:myBubble];
        [self addChild:myBubble];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pause) name:@"single_pause" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unpause) name:@"single_unpause" object:nil];
        
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    
    //check for game over
    if ([myBubble deaths] >= NUM_LIVES){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!"
                                                        message:@"You ran out of lives."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        long long high = [[defaults valueForKey:@"singleHighScore"] longValue];
        if (((long long)([myBubble totalEaten] * 10)) > high){
            [defaults setObject:[[NSNumber alloc]
                                 initWithLongLong:(long long)([myBubble totalEaten] * 10)]
                         forKey:@"singleHighScore"];
            //send (high) score to game center
        }
        [self.scene.view setPaused:YES];
        return;
    }
    
    //check for deaths
    if (myBubble.radius < 0.5)
    {
        shrink_count = 0;
        [self removeLife];
        [self killAllBubbles];
        [myBubble respawn:CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame))];
        return;
    }
    
    //check to dilate
    if (myBubble.radius > 50.0 && dilate_count == 0)
    {
        dilate_count = DILATE_TICKS;
        shrink_count++;
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"dilate1" ofType:@"wav"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        player.numberOfLoops = 0;
        if([player prepareToPlay])
        {
            [player play];
        }

        NSLog(@"Shrinks: %d", shrink_count);
        return;
    }

    if (dilate_count > 0)
    {
        [self dilate:myBubble.position];
        dilate_count--;
        return;
    }   
    
    [self.delegate done:[NSString stringWithFormat:@"%lld", (long long)([myBubble totalEaten] * 10)]];
    
    //update position of userBubble
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGPoint pos = CGPointMake(myBubble.position.x+([myBubble getSpeed])*joystick.x, myBubble.position.y);
    if (CGRectContainsPoint(bounds,pos)){
        myBubble.position = pos;
    }
    pos = CGPointMake(myBubble.position.x, myBubble.position.y+([myBubble getSpeed])*joystick.y);
    if (CGRectContainsPoint(bounds,pos)){
        myBubble.position = pos;
    }
    
    
    //update aibubbles
    [self clearDeadBubbles:bounds];
    [self processEats];
    [myBubble updateArc];
    
    //spawn more bubbles if necessary
    if (MAX(0, (int)(initial_count - (int)[bubbles count] + shrink_count)) > arc4random() % 100)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AIBubble *bubble = [self spawnBubble];
            dispatch_async(dispatch_get_main_queue(), ^{
                [bubbles addObject:bubble];
                [self addChild:bubble];
            });
        });
    }
    
}

-(void) processEats{
    for (AIBubble *b1 in bubbles) {
        for (AIBubble *b2 in bubbles) {
            if (![b1 isEqual:b2] && [b1 collidesWith:b2]) {
                if (b1.radius < b2.radius) {
                    [b2 eat:b1 withMultiplier:shrink_count];
                }
                else if (b1.radius > b2.radius) {
                    [b1 eat:b2 withMultiplier:shrink_count];
                }
            }
        }
    }
}

-(void) clearDeadBubbles:(CGRect)bounds{
    
    NSMutableIndexSet *removeIndices = [[NSMutableIndexSet alloc] init];
    
    for (int i = 1; i < [bubbles count]; i++)
    {
        Bubble *b = [bubbles objectAtIndex:i];
        if ([b isEqual:myBubble]){
            continue;
        }
        if (b.radius < 0.5 || !CGRectContainsPoint(bounds,b.position) || b.radius > 100.0)
        {
            [removeIndices addIndex:i];
            [b removeFromParent];
        }
        else
        {
            [(AIBubble*)b updatePosition];
            [b updateArc];
        }
    }
    
    [bubbles removeObjectsAtIndexes:removeIndices];
}

-(void) killAllBubbles{
    NSMutableIndexSet *removeIndices = [[NSMutableIndexSet alloc] init];
    for (short i = 0; i < [bubbles count]; i++){
        Bubble *b = [bubbles objectAtIndex:i];
        if ([b isEqual:myBubble]){
            continue;
        }
        else{
            [b removeFromParent];
            [removeIndices addIndex:i];
        }
    }
    [bubbles removeObjectsAtIndexes:removeIndices];
}

-(void) pause
{
    [self.scene.view setPaused:YES];
}

-(void) unpause
{
    [self.scene.view setPaused:NO];
}

-(void)addLife:(short)i{
    SKSpriteNode *life = [SKSpriteNode spriteNodeWithImageNamed:@"bubble_icon.png"];
    [life setScale:.020];
    life.position = CGPointMake(15*(i+1), CGRectGetMaxY(self.frame)-15);
    life.zPosition = MAXFLOAT;
    [self addChild: life];
    [lives addObject:life];
}

-(void)dilate:(CGPoint)pos{
    for (Bubble *b in bubbles){
        [b setRadius:DILATE_PERCENT * b.radius];
        [b updateArc];
        double dx = b.position.x - pos.x;
        double dy = b.position.y - pos.y;
        b.position = CGPointMake(pos.x + DILATE_PERCENT*dx, pos.y + DILATE_PERCENT*dy);
    }
    
}

-(void)removeLife{
    SKSpriteNode *s = [lives lastObject];
    [s removeFromParent];
    [lives removeLastObject];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Game Over!"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"single_quit" object:nil];
    }
}

- (AIBubble *)spawnBubble{
    AIBubble *bubble;
    if (myBubble){
        bubble = [[AIBubble alloc] initFromRadius:[myBubble radius]];
    }
    else{
        bubble =[[AIBubble alloc] init];
    }
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
    return bubble;
}

@end