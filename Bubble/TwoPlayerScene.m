//
//  TwoPlayerScene.m
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "TwoPlayerScene.h"


AIBubble* findBubbleInArray(NSArray* arr, AIBubble *b){
    for (AIBubble *bub in arr){
        if ([bub idnum] == [b idnum]){
            return b;
        }
    }
    return nil;
}

@implementation TwoPlayerScene
{
    Bubble* playertwobubble;
}

@synthesize delegate;

-(void)done:(NSString*)dataText{
}

-(void)match:(GKMatch*)match didReceiveData:(NSData*)data fromPlayer:(NSString *)playerID{
    NSDictionary *dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSArray *receivedBubbles = (NSArray*) [NSKeyedUnarchiver
                                           unarchiveObjectWithData:[dict valueForKey:@"myBubbleArray"]];
    double radius = [[dict valueForKey:@"myBubbleRadius"] doubleValue];
    CGPoint pos = [[dict valueForKey:@"myBubblePosition"] CGPointValue];
    int idnum = [[dict valueForKey:@"myBubbleID"] intValue];
    [self extractBubblesFromArray:receivedBubbles];
    if (playertwobubble == nil){
        playertwobubble = [[Bubble alloc] initWithId:idnum andRadius:radius andPosition:pos];
        [self addChild:playertwobubble];
    }
    else{
        playertwobubble.radius = radius;
        playertwobubble.position = pos;
    }
}

-(void)extractBubblesFromArray:(NSArray*)array{
    for (AIBubble *b in array){
        AIBubble *bub = findBubbleInArray(bubbles,b);
        if (bub != nil){
            bub.position = [b position];
            bub.radius = [b radius];
            [bub updateArc];
        }
        else{
            [bubbles addObject:b];
            [self addChild:b];
        }
    }
}


-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime];
    
    if([myBubble collidesWith:playertwobubble]) {
        if (myBubble.radius < playertwobubble.radius) {
            [myBubble eat:playertwobubble withMultiplier:shrink_count];
        }
        else if (myBubble.radius > playertwobubble.radius) {
            [myBubble eat:playertwobubble withMultiplier:shrink_count];
        }
    }
    [playertwobubble updateArc];
    
    NSData *myBubbleArray = [NSKeyedArchiver archivedDataWithRootObject:bubbles];
    NSValue *myBubblePosition = [NSValue valueWithCGPoint:[myBubble position]];
    NSNumber *myBubbleRadius = [[NSNumber alloc] initWithDouble:[myBubble radius]];
    NSNumber *myBubbleID = [[NSNumber alloc] initWithInt:[myBubble idnum]];
    NSArray *values = @[myBubblePosition, myBubbleRadius, myBubbleID, myBubbleArray];
    NSArray *keys = @[@"myBubblePosition", @"myBubbleRadius", @"myBubbleID", @"myBubbleArray"];
    NSDictionary *bubbleToSend = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:bubbleToSend];
    [delegate sendBubbleData:dataToSend];
}

@end