//
//  ButtonBubble.m
//  Bubble
//
//  Created by Jeff Chen on 1/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "ButtonBubble.h"

@implementation ButtonBubble
-(id) init
{
    self = [super initWithColor:[SKColor grayColor]];
    if (self)
    {
        super.alpha = 0.3;
        _down = false;
        _type = 'U';
    }
    
    return self;
}
-(void)setDown : (bool)down
{
    _down = down;
}

-(bool)down
{
    return _down;
}
@end
