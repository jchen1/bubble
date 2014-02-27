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

int contains(NSMutableArray *arr, NSString* id){
    for (UserBubble *b in arr){
        if ([[b idnum] isEqualToString:id]){
            return [arr indexOfObject:b];
        }
    }
    return -1;
}

@implementation MyScene



@synthesize delegate;

-(void)done:(NSString*)dataText{
    dataText = globalData1;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        globalData1 = @"";
        /* Setup your scene here */
        self.joystick = [[JCJoystick alloc] initWithControlRadius:40 baseRadius:45 baseColor:[SKColor grayColor] joystickRadius:25 joystickColor:[SKColor whiteColor]];
        [self.joystick setPosition:CGPointMake(180,70)];
        [self addChild:self.joystick];
        _joystick.alpha = .5;
        _joystick.zPosition= 120;

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
        
        [self generateBubbles:rand()];

    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    globalData1=@"";
    int tmpid; //these variables yo
    char tmpchar; //see comments for hypothesized use
    float tmpRad; //dont think i will actually need them
    float tmpX;
    float tmpY;
//    bool isInDataString=false;
    /* Called before each frame is rendered */
//    [self removeChildrenInArray:multiplayerbubbles];
    
    //NEED A TOSTRING FOR ID OR SOMETHING. THIS CURRENTLY WORKS TO ADD THE BUBBLE TO THE GLOBAL DATA STRING AND SENDS IT BUT EVERY TIME THE BUBBLE MOVES, IT ACQUIRES A NEW TOSTRING SO THIS RECOGNIZES IT AS A DIFF BUBBLE AND APPENDS IT TO DATASTRING. GOTTA ONLY LOOK AT BUTTON IDS INSTEAD OF TOSTRINGS.
    
    if ([globalData1 rangeOfString:[myBubble idnum]].location == NSNotFound) {
        globalData1 = [globalData1 stringByAppendingString:myBubble.toString];
        NSLog(@"myBubble isn't in the data string. Add it to the string");
        NSLog(@"myBubble.toString: %@", myBubble.toString);
    } else {
        //globalData1 contains myBubble info so we just need to update the entry corresponding to myBubble ID
//        NSLog(@"globaldataa")
//        globalData1 = [globalData1 stringByAppendingString:myBubble.toString];
        //NSLog(@"[myBubble idnum]: =%@", [myBubble idnum]);
        //NSLog(@"globaldata: =%@", globalData1);
        //NSLog(@"add bubble! myBubble Not found");
    }
    
    //[self.delegate done:myBubble.toString];
    //add own bubble data to global variable channel1
    //AIGHT I THINK THIS IS HOW WE'RE GONNA DO IT  WE GOTTA MAKE A WORKABLE COPY OF THE BUBBLE DATA STRING ON CHANEL 1
    //THEN WERE GONNA LOAD THE STRING BY PARSING WITH SSCANF
    //THEN WE RE GONNA ADD OUR BUBBLE TO THE STRING IF WE DO A SEARCH OF THE LOADED DATA STRUCTURE AND DONT FIND OUR OWN NAME
    NSString *bubbleString;
    bubbleString = myBubble.toString;
    
    

    
    
    //NSLog(@"%@", multiplayerbubbles);
    //NSLog(@"multiplayerbubble array: %@",[multiplayerbubbles componentsJoinedByString:@","]);
    
    //load data string into array
    const char *cString = [globalData1 cStringUsingEncoding:NSASCIIStringEncoding];
    int i = 0, bytes = 0;
    
    while(5==sscanf(cString, "%d %c %f %f %f %n", &tmpid, &tmpchar, &tmpRad, &tmpX, &tmpY, &bytes))
    {
        if (![[NSString stringWithFormat:@"%d",tmpid] isEqualToString:[myBubble idnum]]){
            int temp = contains(bubbles,[NSString stringWithFormat:@"%d",tmpid]);
            if (temp < 0){
                UserBubble *tmpBubble = [[UserBubble alloc] initWithId:[NSString stringWithFormat:@"%d",tmpid]
                                                 andRadius:15 andXcoord:tmpX andYcoord:tmpY];
                [bubbles addObject:tmpBubble];
                [self addChild:tmpBubble];
            }
            else{
                UserBubble *tmpBubble = [bubbles objectAtIndex:temp];
                [tmpBubble updateRadius: tmpRad];
                CGPoint pnt = CGPointMake(tmpX,tmpY);
                [tmpBubble setPosition:pnt];
                NSLog(@"tmpBubble: %@",[tmpBubble toString]);
                //printf("%s", cString);
            }
        }
        i++;
        cString += bytes;
    }
    for (int i=0; i<[bubbles count]; i++) { //loops through multiplayerbubbles and identifies each string
        UserBubble *obj = (UserBubble*)[bubbles objectAtIndex:i];
        //NSLog(@"Selected: %@", obj.idnum);
        //NSLog(@"Radius: %f", obj.radius);
    }
    
    
    //UNCOMMENT ONCE GLOBAL STRING VERIFIES TO WORK
  //if(!isInDataString)
    //  globalData1 = [globalData1 stringByAppendingString:myBubble.toString];

    //search for presence of bubble
    
    //add self if not already present
    
    //globalData1 = [globalData1 stringByAppendingString:myBubble.toString];
    //globaldata1 = [globaldata1 stringByAppendingString:@"sadsadf"];
    


    //globaldata1 = myBubble.toString;
    [self.delegate done:myBubble.toString];
    
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

@end
