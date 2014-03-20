//
//  viewControllerDelegate.h
//  Bubble
//
//  Created by Rolando Schneiderman on 3/19/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol viewControllerDelegate <NSObject>

-(void)done:(NSString*)dataText;

@end