//
//  AppDelegate.h
//  Bubble
//
//  Created by Jeff Chen on 1/27/14.
//  Copyright (c) 2014 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"
#import "iRate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    SplashViewController *splash;
    GameCenterController *gc;
}

@property (strong, nonatomic) UIWindow *window;

@end
