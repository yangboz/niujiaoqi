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
}
//Background Sprite
@property(nonatomic,retain) CCSprite* backgroundSprite;
//Play animation
@property(nonatomic,retain) CCBAnimationManager* animationManager;
//Animation handler
- (void) onAnimation:(id)sender;
// When pressing the back button, the currently running scene
// is replaced by the start scene, created by CocosBuilder.
- (void) onNext:(id)sender;
- (void) onPrevious:(id)sender;
//Play or pause sound effect
- (void) onSound:(id)sender;

@end
