//
//  TwoPlayerViewController.h
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "TwoPlayerScene.h"
#import "viewControllerDelegate.h"
#import <GameKit/GameKit.h>

//uncomment the next line to test out twoplayer mode
//#define TWOPLAYER


@interface TwoPlayerViewController : SinglePlayerViewController
    <MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate, NSStreamDelegate, viewControllerDelegate, GKMatchmakerViewControllerDelegate, UINavigationControllerDelegate>{
    
        MCBrowserViewController *browserVC;
        MCAdvertiserAssistant *advertiser;
        MCSession *mySession;
        MCPeerID *myPeerID;
        UIButton *browseButton;
        NSInputStream *inputStream;
        NSOutputStream *outputStream;
        
}

-(void)done:(NSString *)dataText;

@end
