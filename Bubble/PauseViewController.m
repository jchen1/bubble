//
//  PauseViewController.m
//  Bubble
//
//  Created by Stephen Greco on 2/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "PauseViewController.h"

@interface PauseViewController ()

@property (nonatomic, strong) UIButton *pauseButton;

@end

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
    
    self.pauseButton =  [UIButton buttonWithType:UIButtonTypeInfoDark ] ;
    CGRect buttonRect = self.pauseButton.frame;
    
    // CALCulate the bottom right corner
    buttonRect.origin.x = self.view.frame.size.width - buttonRect.size.width - 8;
    buttonRect.origin.y = buttonRect.size.height - 8;
    [self.pauseButton setFrame:buttonRect];
    
    [self.pauseButton addTarget:self action:@selector(unpause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unpause {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"single_unpause" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
