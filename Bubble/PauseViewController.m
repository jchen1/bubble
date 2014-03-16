//
//  PauseViewController.m
//  Bubble
//
//  Created by Stephen Greco on 2/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "PauseViewController.h"

@interface PauseViewController ()

@property (nonatomic, strong) UIButton *unpauseButton;
@property (nonatomic, strong) UIButton *quitButton;

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
    
    UIImage *resumeButtonBackground = [[UIImage imageNamed:@"resume_button.png"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(200,600,200,600)];
    UIImage *quitButtonBackground = [[UIImage imageNamed:@"quit_button.png"]
                                       resizableImageWithCapInsets:UIEdgeInsetsMake(200,600,200,600)];
    
    self.unpauseButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [self.unpauseButton setFrame:CGRectMake(50.0, 200.0, 200.0, 50.0)];
    [self.unpauseButton setBackgroundImage:resumeButtonBackground forState:UIControlStateNormal];
    [self.unpauseButton addTarget:self action:@selector(unpause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.unpauseButton];
    
    self.quitButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [self.quitButton setFrame:CGRectMake(50.0, 300.0, 200.0, 50.0)];
    [self.quitButton setBackgroundImage:quitButtonBackground forState:UIControlStateNormal];
    [self.quitButton addTarget:self action:@selector(quitGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.quitButton];
    
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

- (IBAction)quitGame {
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"single_quit" object:nil];
}

@end
