//
//  GameOver.m
//  Orbit
//
//  Created by Dana Griffin on 10/1/14.
//  Copyright (c) 2014 Dana Griffin. All rights reserved.
//

#import "GameOver.h"
#import "GameScene.h"
@implementation GameOver

-(void)didMoveToView:(SKView *)view{
    self.backgroundColor = [SKColor blackColor];
    
    SKLabelNode *gameOver = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    gameOver.text = @"Game Over!";
    gameOver.fontColor = [SKColor whiteColor];
    gameOver.fontSize = 44;
    gameOver.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:gameOver];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    long score = [prefs integerForKey:@"score"];
    NSString *scoreLabel = [NSString stringWithFormat:@"Data collected: %ld mb", score];
    
    SKLabelNode *scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    scoreLabelNode.text = scoreLabel;
    scoreLabelNode.fontColor = [UIColor whiteColor];
    scoreLabelNode.fontSize = 25;
    scoreLabelNode.position = CGPointMake(self.size.width/2, self.size.height/3);
    [self addChild:scoreLabelNode];
    
    SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    tryAgain.text = @"Tap to play again";
    tryAgain.fontColor = [SKColor whiteColor];
    tryAgain.fontSize = 24;
    tryAgain.position = CGPointMake(self.size.width/2, self.size.height/2 - 50);
    
    SKAction *moveLabel = [SKAction moveToY:(self.size.height/2 - 40) duration:2.0];
    [tryAgain runAction:moveLabel];
    
    //SKAction *explosionSound = [SKAction playSoundFileNamed:@"explosion-02.mp3" waitForCompletion:NO];
    
    //[self runAction:explosionSound];
   
    
    
    [self addChild:tryAgain];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    GameScene *startScreen = [GameScene sceneWithSize:self.size];
    [self.view presentScene:startScreen transition:[SKTransition doorsOpenHorizontalWithDuration:1.0f]];
    
    
}


@end
