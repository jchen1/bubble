//
//  GameModeViewController.m
//  Bubble
//
//  Created by Stephen Greco on 3/24/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "GameModeViewController.h"

@interface GameModeViewController ()

@end

@implementation GameModeViewController

@synthesize delegate;

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
    UIImage *backgroundImage = [UIImage imageNamed:@"mode_pick_background.png"];
    UIImage *normalButtonBackground = [UIImage imageNamed:@"normal_mode_button.png"];
    UIImage *hardButtonBackground = [UIImage imageNamed:@"hard_mode_button.png"];
    
    background = [[UIImageView alloc] initWithImage:backgroundImage];
    int width = 0.8 * self.view.bounds.size.width;
    int height = 1.5 * width;
    background.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - width/2,
                                  CGRectGetMidY(self.view.bounds) - height/2, width, height);
    [self.view addSubview:background];
    
    int buttonWidth = 0.8 * background.frame.size.width;
    normalButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [normalButton setFrame:CGRectMake(CGRectGetMidX(background.frame) - buttonWidth/2,
                                    CGRectGetMaxY(background.frame) - 80,
                                    buttonWidth, buttonWidth/4)];
    [normalButton setBackgroundImage:normalButtonBackground forState:UIControlStateNormal];
    [normalButton addTarget:self action:@selector(normalMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:normalButton];
    
    hardButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [hardButton setFrame:CGRectMake(CGRectGetMidX(background.frame) - buttonWidth/2,
                                     CGRectGetMaxY(background.frame) - 140,
                                     buttonWidth, buttonWidth/4)];
    [hardButton setBackgroundImage:hardButtonBackground forState:UIControlStateNormal];
    [hardButton addTarget:self action:@selector(hardMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hardButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)normalMode{
    [[self view] removeFromSuperview];
    [delegate startNormal];
}

-(IBAction)hardMode{
    [[self view] removeFromSuperview];
    [delegate startHardcore];
}


@end
