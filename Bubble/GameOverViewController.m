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
    int width = 0.8 * self.view.bounds.size.width;
    int height = 1.5 * width;
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
    
    int buttonWidth = 0.8 * background.frame.size.width;
    homeButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [homeButton setFrame:CGRectMake(CGRectGetMidX(background.frame) - buttonWidth/2,
                                    CGRectGetMaxY(background.frame) - 80,
                                    buttonWidth, buttonWidth/4)];
    [homeButton setBackgroundImage:homeButtonBackground forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(quitGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];
    
    shareButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [shareButton setFrame:CGRectMake(CGRectGetMidX(background.frame) - buttonWidth/2,
                                    CGRectGetMaxY(background.frame) - 140,
                                    buttonWidth, buttonWidth/4)];
    [shareButton setBackgroundImage:shareButtonBackground forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(tweetScore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];

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
        NSString *tweetText = [NSString stringWithFormat:@"I just scored %lld on #bubbleOutlast! http://t.co/pAHoAtMxZ0", [self score]];
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


@end
