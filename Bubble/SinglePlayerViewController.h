//
//  SinglePlayerViewController.h
//  Bubble
//

//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SplashViewController.h"
#import "PauseViewController.h"
#import "viewControllerDelegate.h"
#import "GameOverViewController.h"
#import "GameModeViewController.h"
#import "GameCenterController.h"


@interface SinglePlayerViewController : UIViewController <viewControllerDelegate> {
    UIButton *pauseButton;
    UILabel *score;
    AVAudioPlayer*player;
}

- (IBAction)pause;
- (IBAction)popCurrentView;

@property GameCenterController *gc;
@property id<viewControllerDelegate> splash;
@property (nonatomic, strong) UIView *whiteScreen;
@property NSString* level;

@end

extern long long highscore;
