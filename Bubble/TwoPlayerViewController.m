//
//  TwoPlayerViewController.m
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "TwoPlayerViewController.h"

@implementation TwoPlayerViewController{
    TwoPlayerScene *scene;
    SKView * skView;
    GKMatchmaker *matchmaker;
}

- (void) done:(NSString *)dataText{
    
}


- (void)match:(GKMatch *)match didFailWithError:(NSError *)error{
    
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID{
    [scene match:match didReceiveData:data fromPlayer:playerID];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    skView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    skView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.view = skView;
    
#ifndef FPS
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
#else
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
    
    [self gameKitSetup];
    
    UIImage *pauseButtonBackground = [UIImage imageNamed:@"pause_button.png"];
    
    pauseButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [pauseButton setFrame:CGRectMake(self.view.bounds.size.width - 30,
                                     10, 20.0, 25.0)];
    [pauseButton setBackgroundImage:pauseButtonBackground forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnect) name:@"gameQuit" object:nil];
}

-(void)gameKitSetup{
    GKMatchRequest *matchrequest = [[GKMatchRequest alloc] init];
    matchrequest.maxPlayers = 2;
    
    GKMatchmakerViewController *controller = [[GKMatchmakerViewController alloc] initWithMatchRequest:matchrequest];

    controller.matchmakerDelegate = self;

    [self presentViewController:controller animated:YES completion:nil];
    
    matchmaker = [GKMatchmaker sharedMatchmaker];
    [matchmaker
     findMatchForRequest:myMatchRequest
     withCompletionHandler:^(GKMatch *match, NSError *error) {
         if (error) {
             // Handle error
         }
         else {
             scene = [TwoPlayerScene sceneWithSize:skView.bounds.size];
             scene.scaleMode = SKSceneScaleModeAspectFill;
             scene.delegate=self;
             [skView presentScene:scene];
         }
     }];
    
}

- (void)startLookingForPlayers
{
    [matchmaker startBrowsingForNearbyPlayersWithReachableHandler:^(NSString *playerID, BOOL reachable) {
        [playersToInvite addObject:playerID];
        }
     ];
}

- (void)stopLookingForPlayers
{
    [[GKMatchmaker sharedMatchmaker] stopBrowsingForNearbyPlayers];
}


-(void)invite{
    myMatchRequest.playersToInvite = playersToInvite;
    myMatchRequest.inviteMessage = @"Try and pop my bubble(;";
    //myMatchRequest.responsehandler = self.responsehandler;
    
}


- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController
                    didFindMatch:(GKMatch *)match
{
    match.delegate = self;
    myMatch = match;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    scene = [TwoPlayerScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate=self;
    [skView presentScene:scene];
    
}

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] popViewControllerAnimated:NO];
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] popViewControllerAnimated:NO];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (IBAction)pause{
    [player pause];
    [scene pause];
    PauseViewController *pauseMenu = [[PauseViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:pauseMenu];
    [[self view] addSubview: [pauseMenu view]];
}

- (IBAction)resume
{
    if ([self.splash shouldPlayMusic]){
        [player play];
    }
    [scene unpause];
}

- (void)sendBubbleData:(NSData *)data{
    NSError *error;
    [myMatch sendDataToAllPlayers:data withDataMode:GKSendDataUnreliable error:&error];
}

- (void) disconnect{
    [myMatch disconnect];
}

@end
