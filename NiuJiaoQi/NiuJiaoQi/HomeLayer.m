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
#define BUTTON_SOUND_START @"njq_sound_start.mp3"
#define BUTTON_SOUND_SLEEP_MODE @"njq_sound_sleep_mode.mp3"
#define BUTTON_SOUND_PLAY_PAUSE @"njq_sound_play_pause.mp3"
#define BUTTON_SOUND_LANGUAGE @"njq_sound_language_choice.mp3"

#import "SimpleAudioEngine.h"

@implementation HomeLayer

-(id) init
{
	if ((self=[super init])) {
        //Custom staff here.
        //Preload sound effect
        [[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_SOUND_DEFAULT];
        [[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_SOUND_LANGUAGE];
        [[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_SOUND_START];
        [[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_SOUND_SLEEP_MODE];
        [[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_SOUND_PLAY_PAUSE];
        //Disable buttons for versioning(0.0.1)

    }
    return self;
}

- (void) onChinese:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_LANGUAGE];//Play sound effect
}
- (void) onEnglish:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_LANGUAGE];//Play sound effect
}
- (void) onStart:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_START];//Play sound effect
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
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_SLEEP_MODE];
}

-(void) dealloc
{
    [super dealloc];
    //
    [[SimpleAudioEngine sharedEngine] unloadEffect:BUTTON_SOUND_DEFAULT];
    [[SimpleAudioEngine sharedEngine] unloadEffect:BUTTON_SOUND_LANGUAGE];
    [[SimpleAudioEngine sharedEngine] unloadEffect:BUTTON_SOUND_START];
    [[SimpleAudioEngine sharedEngine] unloadEffect:BUTTON_SOUND_SLEEP_MODE];
    [[SimpleAudioEngine sharedEngine] unloadEffect:BUTTON_SOUND_PLAY_PAUSE];}
@end
