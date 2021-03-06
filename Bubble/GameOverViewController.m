//
//  GameOverViewController.m
//  Bubble
//
//  Created by Stephen Greco on 3/24/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.canDisplayBannerAds = YES;
    }
    return self;
}

-(id)initWithScore:(long long)score
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.score=score;
        self.canDisplayBannerAds = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    UIImage *backgroundImage = [UIImage imageNamed:@"game_over_background.png"];
    UIImage *homeButtonBackground = [UIImage imageNamed:@"quit_button.png"];
    UIImage *shareButtonBackground = [UIImage imageNamed:@"share_button.png"];
    
    background = [[UIImageView alloc] initWithImage:backgroundImage];
    int width = MIN(400, 0.8 * self.view.bounds.size.width);
    int height = 1.5 * width;
    float buttonWidth = 0.8*width;
    float buttonHeight = 0.25 * buttonWidth;
    background.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - width/2,
                                  CGRectGetMidY(self.view.bounds) - height/2, width, height);
    [self.view addSubview:background];
    NSString *scoreText = [NSString stringWithFormat:@"%lld", [self score]];
    scoreDisplay = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(background.frame),
                                                          CGRectGetMidY(background.frame) + 10,
                                                          background.frame.size.width, 20)];
    scoreDisplay.text = scoreText;
    scoreDisplay.textAlignment = NSTextAlignmentCenter;
    scoreDisplay.numberOfLines = 1;
    scoreDisplay.textColor = [UIColor whiteColor];
    scoreDisplay.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:scoreDisplay];
    
    homeButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [homeButton setFrame:CGRectMake(CGRectGetMidX(background.frame) - buttonWidth/2,
                                    CGRectGetMaxY(background.frame) - 1.8*buttonHeight,
                                    buttonWidth, buttonWidth/4)];
    [homeButton setBackgroundImage:homeButtonBackground forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(quitGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];
    
    shareButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [shareButton setFrame:CGRectMake(CGRectGetMidX(background.frame) - buttonWidth/2,
                                    CGRectGetMaxY(background.frame) - 3*buttonHeight,
                                    buttonWidth, buttonWidth/4)];
    [shareButton setBackgroundImage:shareButtonBackground forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(tweetScore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    
    bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    [bannerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: bannerView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)quitGame{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gameQuit" object:nil];
}

- (IBAction)tweetScore{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *tweetText = [NSString stringWithFormat:@"I just scored %lld points on #bubbleOutlast! http://t.co/pAHoAtMxZ0", [self score]];
        [tweetSheet setInitialText:tweetText];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Twitter Unavailable"
                                  message:@"Please sign in and make sure you have an Internet connection."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }

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
