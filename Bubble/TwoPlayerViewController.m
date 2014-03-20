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


-(void)done:(NSString*)dataText{
    //NSLog(@"delegate working");
    [self sendText:dataText];
}

- (void)viewDidLoad
{

    
    globalin=@"";
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
    browseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    browseButton.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - 40, 10, 80, 10);
    [browseButton addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
    [browseButton setTitle:@"Bluetooth" forState:UIControlStateNormal];
    [self.view addSubview:browseButton];
    
    [self setUpMultipeer];
    [self showBrowserVC];
    
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
    GKMatchmaker *matchmaker = [GKMatchmaker sharedMatchmaker];
    
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"single_pause" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) setUpMultipeer{
    //  Setup peer ID
    myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    //  Setup session
    mySession = [[MCSession alloc] initWithPeer:myPeerID];
    mySession.delegate = self;
    
    //  Setup BrowserViewController
    browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:mySession];
    browserVC.delegate = self;
    
    //  Setup Advertiser
    advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat" discoveryInfo:nil session:mySession];
    [advertiser start];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream open];
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    self->mySession.delegate = self;
}

- (void) sendText:(NSString*)dataToSend{
    //  Retrieve text from chat box and clear chat box
    NSString *message =dataToSend;
    //  Convert text to NSData
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    //  Send data to connected peers
    NSError *error;
    [mySession sendData:data toPeers:[mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    NSLog(@"sent: %@", dataToSend);
    //  Append your own message to text box
    //[self receiveMessage: message fromPeer: myPeerID];
}

- (void) receiveMessage: (NSString *) message fromPeer: (MCPeerID *) peer{
    //  Create the final text to append
    //NSString *finalText;
    //finalText = message;
    if (peer == myPeerID) {
//        return;
    }
    else{
        //finalText = [NSString stringWithFormat:@"\n%@: %@ \n", peer.displayName, message];
    }
    
    //  Append text to text box
    //self.textBox.text = [self.textBox.text stringByAppendingString:message];
    NSLog(@"received: %@", message);
    globalin = (NSMutableString*)message;
}

#pragma marks MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
    outputStream= [mySession startStreamWithName:@"stream"
                                          toPeer:[[mySession connectedPeers] lastObject] error:nil];
    [advertiser stop];
    outputStream.delegate = self;
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                            forMode:NSDefaultRunLoopMode];
    [outputStream open];
    
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) showBrowserVC{
    [self presentViewController:browserVC animated:YES completion:nil];
}

- (void) dismissBrowserVC{
    [browserVC dismissViewControllerAnimated:YES completion:nil];
    [advertiser stop];
}

#pragma marks UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendText:@""];
    return YES;
}

#pragma marks MCSessionDelegate
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    //  Decode data back to NSString
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //  append message to text box on main thread
    dispatch_async(dispatch_get_main_queue(),^{
        [self receiveMessage: message fromPeer: peerID];
    });
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}
@end
