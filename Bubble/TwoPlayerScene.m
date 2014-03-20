//
//  TwoPlayerScene.m
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "TwoPlayerScene.h"

int contains(NSMutableArray *arr, int idnum){
    for (UserBubble *b in arr){
        if ([b idnum] == idnum){
            return (int)[arr indexOfObject:b];
        }
    }
    return -1;
}


@implementation TwoPlayerScene
{
    Bubble* playertwobubble;
}

@synthesize delegate;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        playertwobubble = [[Bubble alloc] initWithId:0 andRadius:0 andXcoord:0 andYcoord:0];
        [self addChild:playertwobubble];
    }
    return self;
}


-(void)done:(NSString*)dataText{
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

-(void)stringToBubble:(NSMutableString *) data{
    
}

-(void)update:(CFTimeInterval)currentTime {
    int tmpid;
    char tmpchar;
    float tmpRad;
    float tmpX;
    float tmpY;
    globalout=myBubble.toString;
    [self.delegate done:globalout];
    
    while ([globalin isEqual:@""])
        return;
    const char *cString = [globalin cStringUsingEncoding:NSASCIIStringEncoding];
    sscanf(cString, "%d %c %f %f %f", &tmpid, &tmpchar, &tmpRad, &tmpX, &tmpY);
    globalin=@"";
    playertwobubble.radius = tmpRad;
    playertwobubble.position = CGPointMake(tmpX, tmpY);
    playertwobubble.type = tmpchar;
    playertwobubble.idnum = tmpid;
//    playertwobubble = [[Bubble alloc] initWithId:tmpid andRadius:tmpRad andXcoord:tmpX andYcoord:tmpY];
    

    [super update:currentTime];
    
}

@end