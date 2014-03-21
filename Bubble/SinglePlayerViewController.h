//
//  SinglePlayerViewController.h
//  Bubble
//

//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SplashViewController.h"
#import "PauseViewController.h"
#import "viewControllerDelegate.h"


@interface SinglePlayerViewController : UIViewController <viewControllerDelegate> {
    UIButton *pauseButton;
    UILabel *score;
}

- (IBAction)pause;
- (IBAction)popCurrentView;

@property id<viewControllerDelegate> splash;

@end
