//
//  MyScene.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//
///SEE SECONDVIEWCONTROLLER.M TO GET STARTED
///

#import "MyScene.h"

@implementation MyScene
NSString *globalData1 = @"";

@synthesize delegate;

-(void)done:(NSString*)dataText{
    dataText = globalData1;
    NSLog(@"1Sent string: =%@", dataText);
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        globalData1 = @"";
        /* Setup your scene here */
        //[self.delegate done:@"asdf"];
        self.backgroundColor = [SKColor blackColor];

        bubbles = [NSMutableArray array];
        multiplayerbubbles = [NSMutableArray array];

        myBubble = [[UserBubble alloc] init];
        myBubble.position = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame));
        
        //[multiplayerbubbles addObject:myBubble];
        
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
    //double tmpid; //these variables yo
    //char tmpchar; //see comments for hypothesized use
    //float tmp1; //dont think i will actually need them
    //float tmp2;
    //float tmp3;
    //bool isInDataString=false;
    /* Called before each frame is rendered */
    
    
    //NEED A TOSTRING FOR ID OR SOMETHING. THIS CURRENTLY WORKS TO ADD THE BUBBLE TO THE GLOBAL DATA STRING AND SENDS IT BUT EVERY TIME THE BUBBLE MOVES, IT ACQUIRES A NEW TOSTRING SO THIS RECOGNIZES IT AS A DIFF BUBBLE AND APPENDS IT TO DATASTRING. GOTTA ONLY LOOK AT BUTTON IDS INSTEAD OF TOSTRINGS.
    
    if ([globalData1 rangeOfString:[myBubble idnum]].location == NSNotFound) {
        globalData1 = [globalData1 stringByAppendingString:myBubble.toString];
    } else {
//        globalData1 = [globalData1 stringByAppendingString:myBubble.toString];
        //NSLog(@"add my bubble");
    }
    
    //[self.delegate done:myBubble.toString];
    //add own bubble data to global variable channel1
    //AIGHT I THINK THIS IS HOW WE'RE GONNA DO IT  WE GOTTA MAKE A WORKABLE COPY OF THE BUBBLE DATA STRING ON CHANEL 1
    //THEN WERE GONNA LOAD THE STRING BY PARSING WITH SSCANF
    //THEN WE RE GONNA ADD OUR BUBBLE TO THE STRING IF WE DO A SEARCH OF THE LOADED DATA STRUCTURE AND DONT FIND OUR OWN NAME
    NSString *bubbleString;
    bubbleString = myBubble.toString;
    
    //load data string into array
    
    
        /*
    const char *cString = [globalData1 cStringUsingEncoding:NSASCIIStringEncoding];
    int i = 0;
    while(5==sscanf(cString, "%lf %c %f %f %f ", &tmpid, &tmpchar, &tmp1, &tmp2, &tmp3))
    {
        if(tmpid==myBubble.idnum)
            isInDataString = true;
        //strstr(cString, myBubble.idnum);
        
        //tmpid = id of scanned bubble
        //tmpchar = type of scanned bubble
        //tmp1 = radius of scanned bubble
        //tmp2 = x position of scanned bubble
        //tmp3 = y position of scanned bubble
        
        
        //instance varsiables are all protected what do i do jeff pls
        
        //tmpBubble = [[UserBubble alloc] init];
        //tmpBubble.position.x =tmp2;
        
        
        [tmpBubble setRadius:tmp1];
        //tmpBubble.position.x = tmp2;
        
        //tmpBubble->_type=tmpchar;
        //tmpBubble->_radius =
        
        //bubble.toString
        //return [NSString stringWithFormat:@"%f %c %f %f %f  ", idnum, _type, _radius, super.position.x, super.position.y];
        
//        [multiplayerbubbles addObject:tmpBubble];
        i++;
    }*/
    
    //UNCOMMENT ONCE GLOBAL STRING VERIFIES TO WORK
  //if(!isInDataString)
    //  globalData1 = [globalData1 stringByAppendingString:myBubble.toString];

    //search for presence of bubble
    
    //add self if not already present
    
    //globalData1 = [globalData1 stringByAppendingString:myBubble.toString];
    //globaldata1 = [globaldata1 stringByAppendingString:@"sadsadf"];
    


    //globaldata1 = myBubble.toString;
    [self.delegate done:globalData1];
    
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
