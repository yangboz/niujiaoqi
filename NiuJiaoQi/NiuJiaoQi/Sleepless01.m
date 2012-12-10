//
//  Sleepless01.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-2.
//  Copyright 2012年 godpaper. All rights reserved.
//

#import "Sleepless01.h"
#import "CCBReader.h"
#import "SimpleAudioEngine.h"
#import "CCBAnimationManager.h"

// The TestHeader is embedded in all Test scenes. It contains
// a title and a back button. The title assigned to the owner,
// and the this class only handles the back button.
@implementation Sleepless01

@synthesize animationManager;

// When pressing the back button, the currently running scene
// is replaced by the start scene, HelloCocosBuilder.
- (void) onNext:(id)sender
{
//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:@"Sleepless02.ccbi"] withColor:ccc3(0, 0, 0)]];
     [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:@"Sleepless02.ccbi"]]];
}

// When pressing the back button, the currently running scene
// is replaced by the start scene, HelloCocosBuilder.
//- (void) onPrevious:(id)sender
//{
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:@"Sleepless01.ccbi"] withColor:ccc3(0, 0, 0)]];
//}

//Play or pause sound effect
- (void) onSound:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"njq_sound_01.mp3" loop:YES];
}

//Play animation
- (void) onAnimation_wolf:(id)sender
{
    CCNode* myNodeGraph = [CCBReader nodeGraphFromFile:@"Sleepless01.ccbi"];
    animationManager = myNodeGraph.userObject;
//    [animationManager runAnimationsForSequenceNamed:@"timeline_wolf"];
    [animationManager runAnimationsForSequenceNamed:@"timeline_wolf" tweenDuration:0.5f];
}

-(void)dealloc
{
[animationManager release];
[super dealloc];
}

@end
