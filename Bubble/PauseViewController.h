//
//  PauseViewController.h
//  Bubble
//
//  Created by Stephen Greco on 2/28/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface PauseViewController : UIViewController <ADBannerViewDelegate>{
    UIButton *resumeButton;
    UIButton *quitButton;
    ADBannerView *bannerView;
}


@end
