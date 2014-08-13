//
//  GameLevelScene.h
//  SuperKoalio
//

//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKEmitterNode+SKTExtras.h"
#import "viewControllerDelegate.h"

@interface GameLevelScene : SKScene <viewControllerDelegate>
{
    UIButton *replay;
}
- (instancetype)initWithSize:(CGSize)size andLevel:(NSString *)level;
@property NSString* level;
@property BOOL isPaused;
@property id<viewControllerDelegate> delegate;
@end
