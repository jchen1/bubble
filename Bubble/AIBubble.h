//
//  AIBubble.h
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "Bubble.h"
#include <stdlib.h>

@interface AIBubble : Bubble

@property int preferredDirection;

-(void)updatePosition;

@end
