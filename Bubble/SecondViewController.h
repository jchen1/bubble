//
//  SecondViewController.h
//  Bubble
//
//  Created by Rolando Schneiderman on 1/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"



#define GLOBALDATA

extern NSString *globalData1;


@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *settingsbutton;
@property (weak, nonatomic) IBOutlet UIButton *gamebutton;

- (IBAction)gameView:(UIButton *)sender;

@end

