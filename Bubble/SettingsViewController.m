//
//  SettingsViewController.m
//  Bubble
//
//  Created by Rolando Schneiderman on 1/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController


- (IBAction) goBack{
    [defaults setFloat:musicVolumeSlider.value forKey:@"musicVolume"];
    //[defaults setFloat:sfxVolumeSlider.value forKey:@"sfxVolume"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    defaults = [NSUserDefaults standardUserDefaults];
	
    UIImage *backButtonBackground = [UIImage imageNamed:@"back_button.png"];
    
    backButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [backButton setFrame:CGRectMake(60.0, self.view.bounds.size.height - 100.0, 200.0, 50.0)];
    [backButton setBackgroundImage:backButtonBackground forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    copyright = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100, 50, 200, 100)];
    copyright.lineBreakMode = NSLineBreakByWordWrapping;
    copyright.textAlignment = NSTextAlignmentCenter;
    copyright.numberOfLines = 0;    
    copyright.textColor = [UIColor whiteColor];
    copyright.text = @"created by:\n\nStephen Greco\nRolando Schneiderman";
    [self.view addSubview:copyright];
    
    float musicVolume = [defaults floatForKey:@"musicVolume"];
    //float sfxVolume = [[defaults valueForKey:@"sfxVolume"] floatValue];
    
    musicVolumeLabel= [[UILabel alloc] initWithFrame:CGRectMake(60.0, self.view.bounds.size.height - 210.0, 200, 30)];
    musicVolumeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    musicVolumeLabel.textAlignment = NSTextAlignmentCenter;
    musicVolumeLabel.numberOfLines = 1;
    musicVolumeLabel.textColor = [UIColor whiteColor];
    musicVolumeLabel.text = @"Music Volume";
    [self.view addSubview:musicVolumeLabel];
    
    
    musicVolumeSlider = [[UISlider alloc]
                         initWithFrame:CGRectMake(60.0,self.view.bounds.size.height - 180.0, 200.0, 50.0)];
    musicVolumeSlider.maximumValue = 1.0;
    musicVolumeSlider.minimumValue = 0.001;
    if (musicVolume == 0){
        musicVolumeSlider.value = 1.0;
    }
    else{
        musicVolumeSlider.value = musicVolume;
    }
    
    [musicVolumeSlider addTarget:self action:@selector(musicValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:musicVolumeSlider];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:@"gameQuit" object:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)musicValueChanged:(UISlider *)sender {
    [self.splash setVolume:sender.value];
}

@end
