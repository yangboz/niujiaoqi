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

@interface InteractivePaper : CCLayer {
    CCBAnimationManager* animationManager;
    CCSprite *backgroundSprite;
    //Sound buttons
    CCMenuItem *btn_sound_play;
    CCMenuItem *btn_sound_stop;
}
//Background Sprite
@property(nonatomic,retain) CCSprite* backgroundSprite;
//Play animation
@property(nonatomic,retain) CCBAnimationManager* animationManager;
//Sound buttons
@property(nonatomic,retain) CCMenuItem *btn_sound_play;
@property(nonatomic,retain) CCMenuItem *btn_sound_stop;
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
