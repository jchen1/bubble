//
//  StalkerBubble.m
//  Bubble
//
//  Created by Stephen Greco on 3/23/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "StalkerBubble.h"

@implementation StalkerBubble

@synthesize stalking;

- (id) initToStalk:(Bubble*)other {
    if (self = [super initWithColor:[UIColor orangeColor]]){
        stalking = other;
        self.radius = other.radius + 5.0;
    }
    return self;
}

- (void) updatePosition {
    CGPoint target = stalking.position;
    CGPoint pos = self.position;
    float dx = target.x - pos.x;
    float dy = target.y - pos.y;
    float distance = sqrtf(dx*dx + dy*dy);
    pos.x += dx * [super getSpeed] / distance;
    pos.y += dy * [super getSpeed] / distance;
    [super setPosition:pos];
}

@end
