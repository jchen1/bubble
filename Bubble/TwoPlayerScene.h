//
//  TwoPlayerScene.h
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerScene.h"
#import "TwoPlayerViewController.h"
#import "viewControllerDelegate.h"

@interface TwoPlayerScene : SinglePlayerScene <viewControllerDelegate>{
    NSString *globalData;
}

@property id <viewControllerDelegate> delegate;

@end

