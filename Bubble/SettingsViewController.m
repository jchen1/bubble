//
//  SettingsViewController.m
//  Bubble
//
//  Created by Rolando Schneiderman on 1/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController


- (IBAction) goBack{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    
    self.view.backgroundColor = [UIColor blackColor];
	
    UIImage *backButtonBackground = [UIImage imageNamed:@"back_button.png"];
    
    self.backButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [self.backButton setFrame:CGRectMake(60.0, 470.0, 200.0, 50.0)];
    [self.backButton setBackgroundImage:backButtonBackground forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100, 50, 200, 200)];
    copyright.lineBreakMode = NSLineBreakByWordWrapping;
    copyright.textAlignment = NSTextAlignmentCenter;
    copyright.numberOfLines = 0;
    copyright.textColor = [UIColor whiteColor];
    copyright.text = @"created by:\n\nJeff Chen\nStephen Greco\nRolando Schneiderman";
    [self.view addSubview:copyright];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
