//
//  SinglePlayerViewController.h
//  Bubble
//

//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SplashViewController.h"
#import "PauseViewController.h"
#import "viewControllerDelegate.h"
#import "GameOverViewController.h"


@interface SinglePlayerViewController : UIViewController <viewControllerDelegate> {
    UIButton *pauseButton;
    UILabel *score;
    AVAudioPlayer*player;
}

- (IBAction)pause;
- (IBAction)popCurrentView;

@property GameCenterController *gc;
@property id<viewControllerDelegate> splash;

@end

extern long long highscore;
