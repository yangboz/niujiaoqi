//
//  InteractivePaper.h
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-14.
//  Copyright 2012年 godpaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CCBReader.h"
#import "CCBAnimationManager.h"
#import "PageContentVO.h"
#import "PageElementVO.h"

@interface InteractivePaper : CCLayer {
    CCBAnimationManager* animationManager;
    CCSprite *backgroundSprite;
    //Sound buttons
    CCMenuItem *btn_sound_play;
    CCMenuItem *btn_sound_stop;
    //MenuItems layer
    CCLayer *layer_menuItems;
    //Curl buttons
    CCMenuItem *btn_curl_next;
    CCMenuItem *btn_curl_prev;
}
//Background Sprite
@property(nonatomic,retain) CCSprite* backgroundSprite;
//Play animation
@property(nonatomic,retain) CCBAnimationManager* animationManager;
//Sound buttons
@property(nonatomic,retain) CCMenuItem *btn_sound_play;
@property(nonatomic,retain) CCMenuItem *btn_sound_stop;
//Layers
@property(nonatomic,retain) CCLayer *layer_menuItems;
//Curl buttons
@property(nonatomic,retain) CCMenuItem *btn_curl_next;
@property(nonatomic,retain) CCMenuItem *btn_curl_prev;
//Animation handler
- (void) onAnimation:(id)sender;
// When pressing the back button, the currently running scene
// is replaced by the start scene, created by CocosBuilder.
- (void) onNext:(id)sender;
- (void) onPrevious:(id)sender;
//Play or pause sound effect
//- (void) onSound:(id)sender;
- (void) onSoundPlay:(id)sender;
- (void) onSoundStop:(id)sender;
- (void) onSoundPause:(id)sender;
//Return home menu
- (void) onHome:(id)sender;

@end
