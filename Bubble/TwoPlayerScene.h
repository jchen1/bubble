//
//  TwoPlayerScene.h
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "TwoPlayerViewController.h"
#import "SinglePlayerScene.h"
#import "viewControllerDelegate.h"

@interface TwoPlayerScene : SinglePlayerScene <viewControllerDelegate>

@property id <viewControllerDelegate> delegate;
@property GameCenterController *gc;

@end

