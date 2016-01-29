//
//  GameScene.m
//  Orbit
//
//  Created by Dana Griffin on 10/1/14.
//  Copyright (c) 2014 Dana Griffin. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"
#import "GameViewController.h"

static const uint32_t planetCategory = 0x1 << 2;
static const uint32_t moonCategory = 0x1 << 1;
static const uint32_t satelliteCategory = 0x1;
@implementation GameScene

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:pointsCounter forKey:@"score"];
    
//    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
//    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    
    if (contact.bodyA.categoryBitMask == moonCategory) {
        NSLog(@"Moon hit");
        [self gameOver];
        
//        explosion.position = self.moon.position;
//        [self addChild:explosion];
    }
        
    if (contact.bodyA.categoryBitMask == planetCategory) {
        NSLog(@"Planet hit");
        [self gameOver];
//        explosion.position = self.planet.position;
//        [self addChild:explosion];
    }
    
    
}

-(void)didMoveToView:(SKView *)view {

    
    // Setting up the scene
    self.backgroundColor = [SKColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
       
    
    self.planet = [SKSpriteNode spriteNodeWithImageNamed:[self randomPlanet]];
    self.moon = [SKSpriteNode spriteNodeWithImageNamed:[self randomMoon]];
    
    
    int planetLowY = 2;
    int planetHighY = 6;
    int rndPlanetY = planetLowY +arc4random() % (planetHighY - planetLowY);
    NSLog(@"%d", rndPlanetY);
    
    // Planet features
    self.planet.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/rndPlanetY );
    self.planet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.planet.frame.size.width/2];
    self.planet.physicsBody.dynamic = NO;
    self.planet.physicsBody.categoryBitMask = planetCategory;
    
    int  moonLowX = -100;
    int  moonHighX = 100;
    int  rndMoonX = moonLowX + arc4random() % (moonHighX - moonLowX);
    int  moonLowY = 100;
    int  moonHighY = 300;
    int  rndMoonY = moonLowY + arc4random() % (moonHighY - moonLowY);
    
    // Moon features
    self.moon.position = CGPointMake(self.planet.position.x + rndMoonX, self.planet.position.y + rndMoonY);
    self.moon.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.moon.frame.size.width/2];
    self.moon.physicsBody.dynamic = NO;
    self.moon.physicsBody.categoryBitMask = moonCategory;
    
    // Moon physics features
    SKFieldNode *moonGravity = [SKFieldNode radialGravityField];
    moonGravity.enabled = true;
    moonGravity.position = self.moon.position;
    moonGravity.strength = 0.6f;
    moonGravity.falloff= 0.1f;
    moonGravity.physicsBody.fieldBitMask = satelliteCategory;
    
    // Planets physics features
    SKFieldNode *planetGravity = [SKFieldNode radialGravityField];
    planetGravity.enabled = true;
    planetGravity.position = self.planet.position;
    planetGravity.strength = 0.9f;
    planetGravity.falloff = 0.1f;
    planetGravity.physicsBody.fieldBitMask = satelliteCategory;
    
    // Score Label
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    scoreLabel.fontColor = [UIColor whiteColor];
    scoreLabel.fontSize = 25;
    scoreLabel.text = @"Score:";
    scoreLabel.position = CGPointMake(50, 25);
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    self.scoreLabel.fontColor = [UIColor whiteColor];
    self.scoreLabel.fontSize = 25;
    self.scoreLabel.position = CGPointMake(200, 25);
    
    
    // Adding nodes to the view
    [self addChild:moonGravity];
    [self addChild:planetGravity];
    [self addChild:self.planet];
    [self addChild:self.moon];
    [self addChild:scoreLabel];
    [self addChild:self.scoreLabel];
    
    
}

-(void)counting{
    pointsCounter += 1;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
    numberOfTouches += 1;
  
    if (numberOfTouches < 2) {
        
    
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            SKSpriteNode *satellite = [SKSpriteNode spriteNodeWithImageNamed:@"satellite.png"];
            satellite.position = location;
            satellite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:satellite.frame.size.width/2];
            
            
            satellite.physicsBody.allowsRotation = NO;
            satellite.physicsBody.dynamic = YES;
            satellite.physicsBody.friction = 0;
            satellite.physicsBody.linearDamping = 0;
            satellite.physicsBody.restitution = 0;
            satellite.physicsBody.categoryBitMask = satelliteCategory;
            
            
            satellite.physicsBody.contactTestBitMask = moonCategory | planetCategory ;
            [self addChild:satellite];
            [satellite.physicsBody applyImpulse:CGVectorMake(8, 8)];
            
            // Scoreboard
            self.scoreTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(counting) userInfo:nil repeats:YES];
            
           
        }
        
    }
   
    
}

-(void)gameOver{
    [self.scoreTimer invalidate];
    
    GameOver *gameOverScene = [GameOver sceneWithSize:self.size];
    [self.view presentScene:gameOverScene transition:[SKTransition doorsCloseHorizontalWithDuration:1.0f]];
}

-(void)update:(CFTimeInterval)currentTime {
    self.scoreString = [NSString stringWithFormat:@"%d mb", pointsCounter];
    self.scoreLabel.text = self.scoreString;
    

}



-(NSString *)randomPlanet{
    
    NSArray *planetsArray = [NSArray arrayWithObjects:@"Saturn.png",@"planet2.png",@"Neptune.png",@"Earth.png", nil];
    int rndNum = arc4random_uniform(4);
    
    return [planetsArray objectAtIndex:rndNum];
}

-(NSString *)randomMoon{
    NSArray *moonsArray = [NSArray arrayWithObjects:@"planet1.png",@"Moon.png",@"Youranus.png",@"Moon2.png", nil];
    int rndNum = arc4random_uniform(4);
    return [moonsArray objectAtIndex:rndNum];
}

@end
