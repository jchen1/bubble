//
//  StalkerBubble.h
//  Bubble
//
//  Created by Stephen Greco on 3/23/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "AIBubble.h"

@interface StalkerBubble : AIBubble

@property Bubble *stalking;

- (id) initToStalk:(Bubble*)other;

@end
