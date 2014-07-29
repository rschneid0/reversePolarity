//
//  Player.m
//  SuperKoalio
//
//  Created by Jake Gundersen on 12/27/13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "Player.h"
#import "SKTUtils.h"

@implementation Player
//1
- (instancetype)initWithImageNamed:(NSString *)name
{
  if (self == [super initWithImageNamed:name]) {
    self.velocity = CGPointMake(0.0, 0.0);
    self.startZone=TRUE;
  }
  return self;
}

- (void)update:(NSTimeInterval)delta
{
    //NSLog(@"%f", 100*delta);
    
    float ySpeed;
  if(self.gravity){
    //NSLog(@"negative gravity");
      ySpeed = -200.0;
  }
  else{
    //NSLog(@"positive gravity");
      
      ySpeed = 450.0;
  }
    self.velocity = CGPointMake(400.0f, ySpeed);
    
    if(self.turbo)
    {
        [self setVelocity:CGPointMake(self.velocity.x, self.velocity.y*3.0)];
    }
    CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, delta);
  self.desiredPosition = CGPointAdd(self.position, velocityStep);
}

- (CGRect)collisionBoundingBox
{
  CGRect boundingBox = CGRectInset(self.frame, 2, 0);
  CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
  return CGRectOffset(boundingBox, diff.x, diff.y);
}


@end
