//
//  GameScene.h
//  Orbit
//

//  Copyright (c) 2014 Dana Griffin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>{
    int pointsCounter;
    int numberOfTouches;
}

@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) NSTimer *scoreTimer;
@property (nonatomic, strong) SKNode *moon;
@property (nonatomic, strong) SKNode *planet;
@property (nonatomic, strong) NSString *scoreString;

-(NSString *)randomPlanet;
-(NSString *)randomMoon;
@end
