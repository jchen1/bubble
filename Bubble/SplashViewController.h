//
//  SecondViewController.h
//  Bubble
//
//  Created by Rolando Schneiderman on 1/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SinglePlayerViewController.h"



#define GLOBALDATA

extern NSString *globalData1;


@interface SplashViewController : UIViewController
@property (weak, nonatomic) UIButton *settingsbutton;
@property (weak, nonatomic) UIButton *gamebutton;

@end

