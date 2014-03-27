//
//  GameOverViewController.h
//  Bubble
//
//  Created by Stephen Greco on 3/24/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <iAd/iAd.h>

@interface GameOverViewController : UIViewController <ADBannerViewDelegate>{
    UIImageView *background;
    UIButton *homeButton;
    UIButton *shareButton;
    UILabel *scoreDisplay;
    ADBannerView *bannerView;
}

@property long long score;

@end
