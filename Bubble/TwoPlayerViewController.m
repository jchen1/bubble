//
//  TwoPlayerViewController.m
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "TwoPlayerViewController.h"
#import <GameKit/GameKit.h>



@implementation TwoPlayerViewController{
    TwoPlayerScene *scene;
}

-(void)done:(NSString *)dataText{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SKView * skView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = skView;
    
#ifndef FPS
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
#else
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
    
    
    UIImage *pauseButtonBackground = [UIImage imageNamed:@"pause_button.png"];
    
    pauseButton =  [UIButton buttonWithType:UIButtonTypeSystem] ;
    [pauseButton setFrame:CGRectMake(self.view.bounds.size.width - 30,
                                     10, 20.0, 25.0)];
    [pauseButton setBackgroundImage:pauseButtonBackground forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(drawPause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    // Create and configure the scene.
    scene = [TwoPlayerScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate=self;

    
    [skView presentScene:scene];
}

-(void)gameKitSetup{
    GKMatchRequest *matchrequest = [[GKMatchRequest alloc] init];
    matchrequest.maxPlayers = 2;
    
    GKMatchmakerViewController *controller = [[GKMatchmakerViewController alloc] initWithMatchRequest:matchrequest];

    controller.matchmakerDelegate = self;
    // show it
    // what is it even trying to do??
    /*
    [self.viewController presentViewController:viewController
                                      animated:YES
                                    completion:nil];
     */
    
    GKMatchmaker *matchmaker = [GKMatchmaker sharedMatchmaker];
    [matchmaker
     findMatchForRequest:myMatchRequest
     withCompletionHandler:^(GKMatch *match, NSError *error) {
         if (error) {
             // Handle error
         }
         else {
             // get ready to play
         }
     }];
    
}

///FINDING NEARBY PLAYERS

- (void)startLookingForPlayers
{
    GKMatchmaker *matchmaker = [GKMatchmaker sharedMatchmaker];
    [matchmaker startBrowsingForNearbyPlayersWithReachableHandler:^(NSString *playerID, BOOL reachable) {
        [playersToInvite addObject:playerID];
        }
     ];
}

- (void)stopLookingForPlayers
{
    // stop looking nearby players
    [[GKMatchmaker sharedMatchmaker] stopBrowsingForNearbyPlayers];
}


///SENDING INVITES

-(void)invite{
    //GKMatchmaker *matchmaker = [GKMatchmaker sharedMatchmaker];
    
    myMatchRequest.playersToInvite = playersToInvite;
    myMatchRequest.inviteMessage = @"Try and pop my bubble(;";
  //  myMatchRequest.responsehandler = self.responsehandler;
    
}


- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController
                    didFindMatch:(GKMatch *)match
{
    // set delegate
    match.delegate = self;
    // Setup match (your code here)
}

-(void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    
    
}

-(void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (IBAction) drawPause{
    PauseViewController *pauseMenu = [[PauseViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:pauseMenu animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
@end
