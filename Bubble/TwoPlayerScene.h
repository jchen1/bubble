//
//  TwoPlayerScene.h
//  Bubble
//
//  Created by Stephen Greco on 3/16/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import "SinglePlayerScene.h"

@protocol ViewControllerDelegate <NSObject>

-(void)done:(NSString*)dataText;

@end

@interface TwoPlayerScene : SinglePlayerScene <ViewControllerDelegate> {
    NSString *globalData;
}


@end