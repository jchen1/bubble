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
    self.view.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    
    UIImage *resumeButtonBackground = [UIImage imageNamed:@"resume_button.png"];
    UIImage *quitButtonBackground = [UIImage imageNamed:@"quit_button.png"];
    
    resumeButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [resumeButton setFrame:CGRectMake(50.0, 200.0, 200.0, 50.0)];
    [resumeButton setBackgroundImage:resumeButtonBackground forState:UIControlStateNormal];
    [resumeButton addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeButton];
    
    quitButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [quitButton setFrame:CGRectMake(50.0, 300.0, 200.0, 50.0)];
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"single_unpause" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)quitGame {
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"single_quit" object:nil];
}

@end
