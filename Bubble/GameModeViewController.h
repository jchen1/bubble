//
//  GameModeViewController.h
//  Bubble
//
//  Created by Stephen Greco on 3/24/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "viewControllerDelegate.h"

@interface GameModeViewController : UIViewController{
    UIImageView *background;
    UIButton *normalButton;
    UIButton *hardButton;
}

@property id<viewControllerDelegate> delegate;

@end
