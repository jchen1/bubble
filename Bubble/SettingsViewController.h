//
//  SettingsViewController.h
//  Bubble
//
//  Created by Rolando Schneiderman on 1/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "viewControllerDelegate.h"


@interface SettingsViewController : UIViewController{
    UIButton *backButton;
    UILabel *copyright;
    UILabel *highScore;
    UILabel *musicVolumeLabel;
    UILabel *sfxVolumeLabel;
    UISlider *musicVolumeSlider;
    UISlider *sfxVolumeSlider;
    NSUserDefaults *defaults;
}

@property id<viewControllerDelegate> splash;

@end
