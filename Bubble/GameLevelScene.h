//
//  GameLevelScene.h
//  SuperKoalio
//

//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKEmitterNode+SKTExtras.h"

@interface GameLevelScene : SKScene
{
    UIButton *replay;
}
- (instancetype)initWithSize:(CGSize)size andLevel:(NSString *)level;
@property NSString* level;
@property BOOL isPaused;
@end
