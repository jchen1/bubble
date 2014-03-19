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

-(void)done:(NSString*)dataText{
    dataText = @"";
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
    /*int tmpid; //these variables yo
    char tmpchar; //see comments for hypothesized use
    float tmpRad; //dont think i will actually need them
    float tmpX;
    float tmpY;*/
    //    bool isInDataString=false;
    /* Called before each frame is rendered */
    //    [self removeChildrenInArray:multiplayerbubbles];
    
    //NEED A TOSTRING FOR ID OR SOMETHING. THIS CURRENTLY WORKS TO ADD THE BUBBLE TO THE GLOBAL DATA STRING AND SENDS IT BUT EVERY TIME THE BUBBLE MOVES, IT ACQUIRES A NEW TOSTRING SO THIS RECOGNIZES IT AS A DIFF BUBBLE AND APPENDS IT TO DATASTRING. GOTTA ONLY LOOK AT BUTTON IDS INSTEAD OF TOSTRINGS.
    
    /*if ([globalData1 rangeOfString:[myBubble idnum]].location == NSNotFound) {
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
        //UserBubble *obj = (UserBubble*)[bubbles objectAtIndex:i];
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
    [self.delegate done:myBubble.toString];*/
    
    [super update:currentTime];
    
}

@end