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


@interface TwoPlayerViewController : SinglePlayerViewController
    <viewControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKInviteEventListener>{

        NSInputStream *inputStream;
        NSOutputStream *outputStream;
        NSMutableArray *playersToInvite;
        GKMatchRequest *myMatchRequest;
        GKMatch *myMatch;
}

-(void)done:(NSString *)dataText;

@end
