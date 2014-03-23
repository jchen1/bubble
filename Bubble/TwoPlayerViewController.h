//
//  TwoPlayerViewController.h
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "TwoPlayerScene.h"
#import "SinglePlayerViewController.h"


@interface TwoPlayerViewController : SinglePlayerViewController <viewControllerDelegate>{

        NSInputStream *inputStream;
        NSOutputStream *outputStream;
}

-(void)done:(NSString *)dataText;
@property GameCenterController* gc;

@end
