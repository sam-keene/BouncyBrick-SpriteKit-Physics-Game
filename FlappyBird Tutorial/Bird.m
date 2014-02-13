//
//  Bird.m
//  FlappyBird Tutorial
//
//  Created by Sam Keene on 2/10/14.
//  Copyright (c) 2014 Sam Keene. All rights reserved.
//

#import "Bird.h"
static const CGFloat bounceImpulse = 20.5;

@implementation Bird

- (void)bounce
{
    CGFloat birdDirection = self.zRotation + M_PI_2;
    self.physicsBody.velocity = CGVectorMake(0, 0);
    [self.physicsBody applyImpulse: CGVectorMake(bounceImpulse*cosf(birdDirection),
                                                    bounceImpulse*sinf(birdDirection))];
}

@end
