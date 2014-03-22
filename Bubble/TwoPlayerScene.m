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
}

@synthesize delegate;


-(void) sendScore:(long long)score
{
    
}


-(void)done:(NSString*)dataText{
}

-(void)match:(GKMatch*)match didReceiveData:(NSData*)data fromPlayer:(NSString *)playerID{
    NSDictionary *dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /*for (UITouch *touch in touches) {
     //CGPoint location = [touch locationInNode:self];
     }*/
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /*for (UITouch *touch in touches) {
     //CGPoint location = [touch locationInNode:self];
     
     }*/
}

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime];
    NSValue *myBubblePosition = [NSValue valueWithCGPoint:[myBubble position]];
    NSNumber *myBubbleRadius = [[NSNumber alloc] initWithDouble:[myBubble radius]];
    NSNumber *myBubbleID = [[NSNumber alloc] initWithInt:[myBubble idnum]];
    NSArray *values = @[myBubblePosition, myBubbleRadius, myBubbleID];
    NSArray *keys = @[@"myBubblePosition", @"myBubbleRadius", @"myBubbleID"];
    NSDictionary *bubbleToSend = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:bubbleToSend];;
    [[self delegate] sendBubbleData:dataToSend];
}

@end