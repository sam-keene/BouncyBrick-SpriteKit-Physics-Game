//
//  MyScene.m
//  FlappyBird Tutorial
//
//  Created by Sam Keene on 2/10/14.
//  Copyright (c) 2014 Sam Keene. All rights reserved.
//

#import "MyScene.h"
#import "Bird.h"

#define kObstacleWidth          55.
#define kObstacleVertSpace      106.
#define kObstacleHorizSpace     170.
#define kMaxHeight              456.    // for base of top obstacle
#define kMinHeight              250.
#define kSpeed                  1.25

@interface MyScene ()
@property (nonatomic, assign) BOOL              gameStarted;
@property (nonatomic, strong) Bird              *bird;
@property (nonatomic, strong) NSMutableArray    *obstacles;
@property (nonatomic, assign) BOOL              isGameOver;
@property (nonatomic, assign) CGFloat         currentDistanceBetweenObstacles;
@end

@implementation MyScene
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.gameStarted = NO;
        self.isGameOver  = NO;
        self.currentDistanceBetweenObstacles = 0;
        
        self.backgroundColor = [SKColor blackColor];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        self.bird = [Bird spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(30, 25)];
        self.bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.bird.size.width/2];
        self.bird.physicsBody.dynamic = NO;
        self.bird.physicsBody.density = 1.5;
        self.bird.physicsBody.linearDamping = 1.;
        self.bird.position = CGPointMake(160, 300);
        [self addChild:self.bird];
       
        self.obstacles = [NSMutableArray array];
        
        [self addNewObstacle];
    }
    return self;
}

- (void)addNewObstacle
{
    SKSpriteNode *obstacleTop = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(kObstacleWidth, 568.)];
    obstacleTop.anchorPoint = CGPointMake(0, 0);
    CGPoint topObstacleBasePoint = CGPointMake(320. + kObstacleWidth, [self randomValueBetween:kMinHeight andValue:kMaxHeight]);
    obstacleTop.position = topObstacleBasePoint;
    
    SKSpriteNode *obstacleBottom = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(kObstacleWidth, 568.)];
    obstacleBottom.anchorPoint = CGPointMake(0, 1);
    obstacleBottom.position = CGPointMake(obstacleTop.position.x, obstacleTop.position.y - kObstacleVertSpace);
    
    [self addChild:obstacleTop];
    [self addChild:obstacleBottom];
    
    [self.obstacles addObject:obstacleTop];
    [self.obstacles addObject:obstacleBottom];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (!self.gameStarted) {
            self.gameStarted = YES;
            self.bird.physicsBody.dynamic = YES;
        }
        [self.bird bounce];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    if (!self.isGameOver && self.gameStarted) {
        
        NSMutableArray *objectsToRemove = [NSMutableArray array];
        self.currentDistanceBetweenObstacles += kSpeed;
        
        if (self.currentDistanceBetweenObstacles >= kObstacleHorizSpace) {
            self.currentDistanceBetweenObstacles = 0;
            [self addNewObstacle];
        }
        
        for (SKSpriteNode *obstacle in self.obstacles) {
            CGPoint currentPos = obstacle.position;
            obstacle.position = CGPointMake(currentPos.x - kSpeed , currentPos.y);
            
            // REMOVE WHEN OFF SCREEN
            if (obstacle.position.x + obstacle.size.width < 0) {
                [obstacle removeFromParent];
                [objectsToRemove addObject:obstacle];
            }
            
            // RUN A BASIC SPRITE HIT TEST
            if ([obstacle intersectsNode:self.bird]) {
                self.isGameOver = YES;
                [self restart];
                break;
            }
        }
        // remove outside of the for loop
        [self.obstacles removeObjectsInArray:objectsToRemove];
    }
}

- (void)restart
{
    for (SKSpriteNode *obstacle in self.obstacles) {
        [obstacle removeFromParent];
    }
   [self.obstacles removeAllObjects];
    
    self.bird.position = CGPointMake(160, 300);
    self.bird.physicsBody.dynamic = NO;
    
    self.gameStarted = NO;
    self.isGameOver  = NO;
    self.currentDistanceBetweenObstacles = 0;
    
    [self addNewObstacle];
    
}

- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

@end
