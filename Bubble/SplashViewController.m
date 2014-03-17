//
//  ViewController.m
//  SimpleChat
//
//  Created by Jeff Chen on 9/27/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//


/*
    THIS IS THE FIRST THING THAT GETS LOADED. IT CAN LOAD SETTINGSVIEWCONTROLLER.C AND ViewController.C FROM THE SCREEN. IT MAKES 2 BUTTONS THAT PUSH THESE VIEWS IN THE SETUPUI METHOD. RIGHT NOW ONLY THE VIEWCONTROLLER HAS A POP BUTTON TO TAKE IT HOME, SO SETTINGS RE-ALLOCATES AND INSTANCIATES A NEW VIEW CONTROLLER OF THIS FIRST IMLEAVING IT FOR TESTING PURPOSES PLS DONT CHANGE EVEN THO IT SEEMS LIKE A BUG. VIEWDIEDLOAD IS THE FIRST THING THAT GETS CALLED. LOOK AROUND MOST FUNCTIONS ARE NAMED APPROPRIATELY (;
*/

#import "SplashViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "SinglePlayerViewController.h"
#import "TwoPlayerViewController.h"
#import "SettingsViewController.h"


@interface SplashViewController ()

@end


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
    TwoPlayerViewController *gameView = [[TwoPlayerViewController alloc] init];
    [self.navigationController pushViewController:gameView animated:NO];
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
    UIImage *bubbleIconImage = [UIImage imageNamed:@"bubble_icon.png"];
    
    self.bubbleicon = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, 100.0, 200.0, 200.0)];
    self.bubbleicon.image = bubbleIconImage;
    [self.view addSubview:self.bubbleicon];
    
    self.gamebutton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [self.gamebutton setFrame:CGRectMake(60.0, 350.0, 200.0, 50.0)];
    [self.gamebutton setBackgroundImage:singlePlayerButtonBackground forState:UIControlStateNormal];
    [self.gamebutton addTarget:self action:@selector(gameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.gamebutton];
    
    self.multibutton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [self.multibutton setFrame:CGRectMake(60.0, 410.0, 200.0, 50.0)];
    [self.multibutton setBackgroundImage:twoPlayerButtonBackground forState:UIControlStateNormal];
    [self.multibutton addTarget:self action:@selector(multiGameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.multibutton];

    self.optionsbutton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [self.optionsbutton setFrame:CGRectMake(60.0, 470.0, 200.0, 50.0)];
    [self.optionsbutton setBackgroundImage:optionsButtonBackground forState:UIControlStateNormal];
    [self.optionsbutton addTarget:self action:@selector(optionsView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.optionsbutton];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
