//
//  SettingsViewController.m
//  Bubble
//
//  Created by Rolando Schneiderman on 1/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SettingsViewController.h"


NSString *globalString = @"someSring";

@interface SettingsViewController ()
@property (nonatomic, strong) UIButton *browseButton;

@end

@implementation SettingsViewController

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
    
    self.browseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.browseButton setTitle:globalString forState:UIControlStateNormal];
    self.browseButton.frame = CGRectMake(130, 20, 60, 30);
    [self.view addSubview:self.browseButton];
    self.view.backgroundColor = [UIColor colorWithRed:200/256.0 green:0/256.0 blue:67/256.0 alpha:1.0];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
