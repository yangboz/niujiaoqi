//
//  Sleepless02.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-3.
//  Copyright 2012年 godpaper. All rights reserved.
//

#import "Sleepless02.h"
#import "CCBReader.h"
#import "SimpleAudioEngine.h"

@implementation Sleepless02

// When pressing the back button, the currently running scene
// is replaced by the start scene, HelloCocosBuilder.
- (void) onPrevious:(id)sender
{
//    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:@"Sleepless01.ccbi"] withColor:ccc3(0, 0, 0)]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:@"Sleepless01.ccbi"] backwards:YES]];
     
}

//Play or pause sound effect
- (void) onSound:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"njq_sound_02.mp3" loop:YES];
}

@end
