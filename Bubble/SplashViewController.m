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
    [self.navigationController pushViewController:gameView animated:YES];
}

- (void) setUpUI{
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *singlePlayerButtonBackground = [UIImage imageNamed:@"1p_button.png"];
    
    self.gamebutton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [self.gamebutton setFrame:CGRectMake(60.0, 400.0, 200.0, 50.0)];
    [self.gamebutton setBackgroundImage:singlePlayerButtonBackground forState:UIControlStateNormal];
    [self.gamebutton addTarget:self action:@selector(gameView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.gamebutton];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
