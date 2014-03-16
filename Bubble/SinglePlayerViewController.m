//
//  ViewController.m
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

///
///SSEE SECONDVIEWCONTROLLER.M TO GET STARTED
///

#import "SinglePlayerViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <SpriteKit/SpriteKit.h>


@interface SinglePlayerViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate, ViewControllerDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;
@property (nonatomic, strong) SinglePlayerScene *scene;

@property (nonatomic, strong) UIButton *browseButton; //no ui things except this one are being displayed
@property (nonatomic, strong) UIButton *pauseButton;

@end

@implementation SinglePlayerViewController
NSString *globalString = @"";

-(void)done:(NSString*)dataText{
    [self sendText:dataText];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SKView * skView = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = skView;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    [self setUpUI];
    [self setUpMultipeer];
    
    // Create and configure the scene.
    SinglePlayerScene * scene = [SinglePlayerScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    self.scene = scene;

    // Present the scene.
    [skView presentScene:scene];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (IBAction)popCurrentView {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void) setUpUI{
    //  Setup the bluetooth button
    self.browseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.browseButton setTitle:@"Bluetooth" forState:UIControlStateNormal];
    self.browseButton.frame = CGRectMake(10, 10, 80, 10);
    [self.view addSubview:self.browseButton];
    [self.browseButton addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
    self.pauseButton =  [UIButton buttonWithType:UIButtonTypeInfoDark ] ;
    CGRect buttonRect = self.pauseButton.frame;
    
    // CALCulate the bottom right corner
    buttonRect.origin.x = self.view.frame.size.width - buttonRect.size.width - 8;
    buttonRect.origin.y = buttonRect.size.height - 8;
    [self.pauseButton setFrame:buttonRect];
    
    [self.pauseButton addTarget:self action:@selector(drawPause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseButton];
}
- (void) setUpMultipeer{
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:self.mySession];
    self.browserVC.delegate = self;
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
}

- (void) showBrowserVC{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (void) dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)drawPause{
    PauseViewController *pauseMenu = [[PauseViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:pauseMenu animated:NO];
    [self.scene pause];
}

- (void) sendText:(NSString*)dataToSend{
    //  Retrieve text from chat box and clear chat box
    NSString *message =dataToSend;
    //  Convert text to NSData
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    //  Send data to connected peers
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    //  Append your own message to text box
    [self receiveMessage: message fromPeer: self.myPeerID];
}

- (void) receiveMessage: (NSString *) message fromPeer: (MCPeerID *) peer{
    //  Create the final text to append
    NSString *finalText;
    finalText = message;
    if (peer == self.myPeerID) {
        finalText = [NSString stringWithFormat:@"\nme: %@ \n", message];
        return;
    }
    else{
        finalText = [NSString stringWithFormat:@"\n%@: %@ \n", peer.displayName, message];
    }
    
    //  Append text to text box
    //self.textBox.text = [self.textBox.text stringByAppendingString:message];
    NSLog(@"received: %@", message);
    globalData1 = message;
}

#pragma marks MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
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
    
    //  append message to text box:
    dispatch_async(dispatch_get_main_queue(), ^{
        [self receiveMessage:message fromPeer:peerID];
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

