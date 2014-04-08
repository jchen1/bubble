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
        self.canDisplayBannerAds = YES;
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
    
    float width = self.view.bounds.size.width;
    float height = self.view.bounds.size.height;
    float buttonWidth = MIN(400, 0.6*width);
    float buttonHeight = 0.25 * buttonWidth;
    
    
    resumeButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [resumeButton setFrame:CGRectMake(0.5 * (width - buttonWidth),
                                      0.5 * height - 1.1*buttonHeight, buttonWidth, buttonHeight)];
    [resumeButton setBackgroundImage:resumeButtonBackground forState:UIControlStateNormal];
    [resumeButton addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeButton];
    
    quitButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [quitButton setFrame:CGRectMake(0.5 * (width - buttonWidth),
                                    0.5 * height + 1.1*buttonHeight, buttonWidth, buttonHeight)];
    [quitButton setBackgroundImage:quitButtonBackground forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
    
    bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    [bannerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: bannerView];
    
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

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error loading");
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad loaded");
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"Ad will load");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Ad did finish");
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
