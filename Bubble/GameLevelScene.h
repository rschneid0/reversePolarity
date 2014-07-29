//
//  GameLevelScene.h
//  SuperKoalio
//

//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameLevelScene : SKScene
{
    UIButton *replay;
}
- (instancetype)initWithSize:(CGSize)size andLevel:(NSString *)level;
@property NSString* level;
@end
