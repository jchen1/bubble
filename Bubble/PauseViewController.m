//
//  PauseViewController.m
//  Bubble
//
//  Created by Stephen Greco on 2/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "PauseViewController.h"

@implementation PauseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    
    UIImage *resumeButtonBackground = [UIImage imageNamed:@"resume_button.png"];
    UIImage *quitButtonBackground = [UIImage imageNamed:@"quit_button.png"];
    
    resumeButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [resumeButton setFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100, 200.0, 200.0, 50.0)];
    [resumeButton setBackgroundImage:resumeButtonBackground forState:UIControlStateNormal];
    [resumeButton addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeButton];
    
    quitButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [quitButton setFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100, 300.0, 200.0, 50.0)];
    [quitButton setBackgroundImage:quitButtonBackground forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resumeGame {
    [[self view] removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gameUnpause" object:nil];
}

- (IBAction)quitGame {
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gameQuit" object:nil];
}

@end
