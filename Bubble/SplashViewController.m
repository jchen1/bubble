//
//  ViewController.m
//  SimpleChat
//
//  Created by Jeff Chen on 9/27/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//


/*
    THIS IS THE FIRST THING THAT GETS LOADED. IT CAN LOAD SETTINGSVIEWCONTROLLER.C AND ViewController.C FROM THE SCREEN. IT MAKES 2 BUTTONS THAT PUSH THESE VIEWS IN THE SETUPUI METHOD. RIGHT NOW ONLY THE VIEWCONTROLLER HAS A POP BUTTON TO TAKE IT HOME, SO SETTINGS RE-ALLOCATES AND INSTANCIATES A NEW VIEW CONTROLLER OF THIS FIRST IMLEAVING IT FOR TESTING PURPOSES PLS DONT CHANGE EVEN THO IT SEEMS LIKE A BUG. VIEWDIEDLOAD IS THE FIRST THING THAT GETS CALLED. LOOK AROUND MOST FUNCTIONS ARE NAMED APPROPRIATELY (;
*/

#import "SplashViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "SinglePlayerViewController.h"


@interface SplashViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate>
{
    UIButton *button;
}
@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@property (nonatomic, strong) UIButton *browserButton;
@property (nonatomic, strong) UITextField *chatBox;
@property (nonatomic, strong) UITextView *textBox;

@end


//extern NSString *globalData1;
//extern NSString *globalString;
//idk man seems prety shady


@implementation SplashViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setUpUI];
    //[self setUpMultipeer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gameView:(id)sender {
//    self.chatBox.text = globalData1;
    //NSLog((@"asdf"));
//    ViewController *gameView = [ViewController alloc];
    
}

- (void) setUpUI{
    self.view.backgroundColor = [UIColor colorWithRed:200/256.0 green:0/256.0 blue:67/256.0 alpha:1.0];
    //  Setup TextBox
    self.textBox = [[UITextView alloc] initWithFrame: CGRectMake(40, 150, 240, 270)];
    self.textBox.editable = NO;
    self.textBox.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: self.textBox];
    
    //  Setup ChatBox
    self.chatBox = [[UITextField alloc] initWithFrame: CGRectMake(40, 60, 240, 70)];
    self.chatBox.backgroundColor = [UIColor lightGrayColor];
    self.chatBox.returnKeyType = UIReturnKeySend;
    self.chatBox.delegate = self;
    [self.view addSubview:self.chatBox];
    
    //rounded buttons!
    CALayer *settingsbtnLayer = [_settingsbutton layer];
    [settingsbtnLayer setMasksToBounds:YES];
    [settingsbtnLayer setCornerRadius:5.0f];
    [settingsbtnLayer setBorderWidth:1.0];
    [settingsbtnLayer setBorderColor:[[UIColor grayColor] CGColor]];
    //YO WE GOTTA FIND SOMEONE WHO CAN MAKE SOME GRAPHIX FOR THE BUTTONS
    //EVERYTHING DRAWABLE IS UGLY
    //IMAGE FILE/VECTOR GRAPHICS R THE WAY TO GO
    //CAN BE DONE FROM STORYBOARD EDITOR TOO 
    
    CALayer *gamebtnLayer = [_gamebutton layer];
    [gamebtnLayer setMasksToBounds:YES];
    [gamebtnLayer setCornerRadius:5.0f];
    [gamebtnLayer setBorderWidth:1.0];
    [gamebtnLayer setBorderColor:[[UIColor grayColor] CGColor]];

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

- (void) sendText{
    //  Retrieve text from chat box and clear chat box
    NSString *message = self.chatBox.text;
    //self.chatBox.text = @"";
    
    //  Convert text to NSData
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    //  Send data to connected peers
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    //  Append your own message to text box
    //[self receiveMessage: message fromPeer: self.myPeerID];
}

- (void) receiveMessage: (NSString *) message fromPeer: (MCPeerID *) peer{
    //  Create the final text to append
    NSString *finalText;
    finalText = message;
    if (peer == self.myPeerID) {
        finalText = [NSString stringWithFormat:@"\nme: %@ \n", message];
    }
    else{
        finalText = [NSString stringWithFormat:@"\n%@: %@ \n", peer.displayName, message];
    }
    
    //  Append text to text box
    self.textBox.text = [self.textBox.text stringByAppendingString:message];
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
    [self sendText];
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
