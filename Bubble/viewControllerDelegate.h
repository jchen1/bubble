//
//  viewControllerDelegate.h
//  Bubble
//
//  Created by Rolando Schneiderman on 3/19/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol viewControllerDelegate <NSObject>

@optional
-(void)done:(NSString*)dataText;

-(void)pauseMusic;

-(void)resumeMusic;

-(void)sendScore:(long long)score;

-(void)sendAchievement:(NSString*)achievementIdentifier;

-(BOOL)shouldPlayMusic;

-(void)setVolume:(float)volume;

-(void)sendBubbleData: (NSData*)data;

@end