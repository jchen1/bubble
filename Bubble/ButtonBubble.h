//
//  ButtonBubble.h
//  Bubble
//
//  Created by Jeff Chen on 1/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "bubble.h"

@interface ButtonBubble : Bubble {
    bool _down;
}

-(void)setDown : (bool)down;
-(bool)down;

@end
