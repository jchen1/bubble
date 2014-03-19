//
//  SplashViewController.m
//  Bubble
//
//  Created by Jeff Chen on 9/27/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//


#import "SplashViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "SinglePlayerViewController.h"
#import "SettingsViewController.h"
#define TWOPLAYER

#ifdef TWOPLAYER
#import "TwoPlayerViewController.h"
#endif


@implementation SplashViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gameView {
    SinglePlayerViewController *gameView = [[SinglePlayerViewController alloc] init];
    [self.navigationController pushViewController:gameView animated:NO];
}

- (IBAction)multiGameView {
    
#ifndef TWOPLAYER    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon!"
                                                    message:@"This feature is still in development."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#else
    TwoPlayerViewController *gameView = [[TwoPlayerViewController alloc] init];
    [self.navigationController pushViewController:gameView animated:NO];
#endif
    
    
}

- (IBAction)optionsView {
    SettingsViewController *settingsView = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsView animated:NO];
}

- (void) setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *singlePlayerButtonBackground = [UIImage imageNamed:@"1p_button.png"];
    UIImage *twoPlayerButtonBackground = [UIImage imageNamed:@"2p_button.png"];
    UIImage *optionsButtonBackground = [UIImage imageNamed:@"options_button.png"];
    UIImage *bubbleIconImage = [UIImage imageNamed:@"bubble_icon_title.png"];
    
    bubbleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, 100.0, 200.0, 200.0)];
    bubbleIcon.image = bubbleIconImage;
    [self.view addSubview:bubbleIcon];
    
    singlePlayerButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [singlePlayerButton setFrame:CGRectMake(60.0, 350.0, 200.0, 50.0)];
    [singlePlayerButton setBackgroundImage:singlePlayerButtonBackground forState:UIControlStateNormal];
    [singlePlayerButton addTarget:self action:@selector(gameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:singlePlayerButton];
    
    twoPlayerButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [twoPlayerButton setFrame:CGRectMake(60.0, 410.0, 200.0, 50.0)];
    [twoPlayerButton setBackgroundImage:twoPlayerButtonBackground forState:UIControlStateNormal];
    [twoPlayerButton addTarget:self action:@selector(multiGameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoPlayerButton];

    optionsButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [optionsButton setFrame:CGRectMake(60.0, 470.0, 200.0, 50.0)];
    [optionsButton setBackgroundImage:optionsButtonBackground forState:UIControlStateNormal];
    [optionsButton addTarget:self action:@selector(optionsView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:optionsButton];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
