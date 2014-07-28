//
//  Player.h
//  SuperKoalio
//
//  Created by Jake Gundersen on 12/27/13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode
@property (nonatomic, assign) CGPoint desiredPosition;
@property CGPoint velocity;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) BOOL forwardMarch;
@property (nonatomic, assign) BOOL mightAsWellJump;
@property (nonatomic, assign) BOOL gravity;
@property (nonatomic, assign) BOOL turbo;
@property BOOL startZone;
- (void)update:(NSTimeInterval)delta;
- (CGRect)collisionBoundingBox;
@end
