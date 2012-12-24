//
//  HomeLayer.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-21.
//  Copyright 2012年 godpaper. All rights reserved.
//

#import "HomeLayer.h"
#import "CCBReader.h"
#define BUTTON_SOUND_DEFAULT @"njq_sound_button.mp3"
#import "SimpleAudioEngine.h"

@implementation HomeLayer

-(id) init
{
	if ((self=[super init])) {
        //Custom staff here.
        //Preload sound effect
        [[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_SOUND_DEFAULT];
        //

    }
    return self;
}

- (void) onChinese:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_DEFAULT];//Play sound effect
}
- (void) onEnglish:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_DEFAULT];//Play sound effect
}
- (void) onStart:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_DEFAULT];//Play sound effect
    //Scene transition
    CCLayer *layer = (CCLayer *) [CCBReader nodeGraphFromFile:@"InteractivePaper.ccbi"];
    
    //        layer.isTouchEnabled = YES;
    
    CCScene *scene = [CCScene node];
    [scene addChild:layer];
    //    [[CCDirector sharedDirector] runWithScene: scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.1f scene:scene]];
}
- (void) onSleeping:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_DEFAULT];
}
@end
