//
//  GameOverViewController.h
//  Bubble
//
//  Created by Stephen Greco on 3/24/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface GameOverViewController : UIViewController{
    UIImageView *background;
    UIButton *homeButton;
    UIButton *shareButton;
    UILabel *scoreDisplay;
}

@property long long score;

@end
