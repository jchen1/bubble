//
//  TwoPlayerScene.m
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "TwoPlayerScene.h"

@implementation TwoPlayerScene
{
    Bubble* playertwobubble;
    NSMutableArray* newBubbles;
}

@synthesize delegate;
@synthesize gc;

-(void)done:(NSString*)dataText{
}

-(void)handleReceivedData:(NSData *)data{
    NSDictionary *dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *receivedBubbleData = (NSMutableArray*)[NSKeyedUnarchiver
                                                           unarchiveObjectWithData:
                                                           [dict valueForKey:@"myNewBubbles"]];
    for (AIBubble *b in receivedBubbleData){
        [bubbles addObject:b];
        [self addChild:b];
    }
    double radius = [[dict valueForKey:@"myBubbleRadius"] doubleValue];
    CGPoint pos = [[dict valueForKey:@"myBubblePosition"] CGPointValue];
    int idnum = [[dict valueForKey:@"myBubbleID"] intValue];
    if (playertwobubble == nil){
        playertwobubble = [[Bubble alloc] initWithId:idnum andRadius:radius andPosition:pos];
        [self addChild:playertwobubble];
    }
    else{
        playertwobubble.radius = radius;
        playertwobubble.position = pos;
    }
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
        [self.gc sendScore:[myBubble totalEaten] *10];
        [gc disconnect];
        return;
    }
    
    //check for deaths
    if (myBubble.radius < DEATH_RADIUS)
    {
        shrink_count = 0;
        [self removeLife];
        [self killAllBubbles];
        [myBubble respawn:CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame))];
        return;
    }
    
    //check to dilate
    if (myBubble.radius > DILATE_RADIUS && dilate_count == 0)
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
    
    if([myBubble collidesWith:playertwobubble]) {
        if (myBubble.radius < playertwobubble.radius) {
            [playertwobubble eat:myBubble withMultiplier:shrink_count];
        }
        else if (myBubble.radius > playertwobubble.radius) {
            [myBubble eat:playertwobubble withMultiplier:shrink_count];
        }
    }
    [playertwobubble updateArc];
    [myBubble updateArc];
    
    //spawn more bubbles if necessary
    if (MAX(0, (int)(initial_count - (int)[bubbles count] + shrink_count)) > arc4random() % 100)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AIBubble *bubble = [self spawnBubble];
            dispatch_async(dispatch_get_main_queue(), ^{
                [bubbles addObject:bubble];
                [newBubbles addObject:bubble];
                [self addChild:bubble];
            });
        });
    }
    
    NSValue *myBubblePosition = [NSValue valueWithCGPoint:[myBubble position]];
    NSNumber *myBubbleRadius = [[NSNumber alloc] initWithDouble:[myBubble radius]];
    NSNumber *myBubbleID = [[NSNumber alloc] initWithInt:[myBubble idnum]];
    NSData *myNewBubbles = [NSKeyedArchiver archivedDataWithRootObject:newBubbles];
    [newBubbles removeAllObjects];
    NSArray *values = [NSMutableArray arrayWithArray:@[myBubblePosition, myBubbleRadius, myBubbleID, myNewBubbles]];
    NSArray *keys = [NSMutableArray arrayWithArray:@[@"myBubblePosition", @"myBubbleRadius",
                                                     @"myBubbleID", @"myNewBubbles"]];
    NSDictionary *bubbleToSend = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:bubbleToSend];
    [gc sendBubbleData:dataToSend];
}

@end