//
//  InteractivePaper.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-14.
//  Copyright 2012年 godpaper. All rights reserved.
//

#import "InteractivePaper.h"
#import "SubjectsModel.h"

@implementation InteractivePaper

@synthesize backgroundSprite;
@synthesize animationManager;
@synthesize btn_sound_play,btn_sound_stop;

//Constants
#define COMIC_BOOK_STRIP_SUFFIX @" 副本.png"
#define MAX_NUM_CBOOK_STRIPS 16
#define CCBI_NAME @"InteractivePaper.ccbi"
#define CCBI_SOUND_PREFIX @"njq_sound_"
#define CCBI_SOUND_SUFFIX @".mp3"

-(id) init
{
	if ((self=[super init])) {
        int currentLevel = [SubjectsModel getLevel];
        //ccbi name split-joint
        NSString *levelStr = [NSString stringWithFormat:@"%d", currentLevel];
        NSMutableString *bgFileName = [NSMutableString stringWithString:levelStr];
        [bgFileName appendString:COMIC_BOOK_STRIP_SUFFIX];
        //Update background sprite
//        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:bgFileName];
//        [self.backgroundSprite setTexture: tex];
//        [self removeChild:backgroundSprite];
        //Anew background to overlay
        CCSprite *anewBG = [CCSprite spriteWithFile:bgFileName];
        [self addChild:anewBG];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        anewBG.position = ccp(winSize.width/2,winSize.height/2);
        //Sound buttons
        CCMenuItem *_plusItem; 
        CCMenuItem *_minusItem;
        _plusItem = [[CCMenuItemImage itemWithNormalImage:@"btn_sound_play.png" 
                                            selectedImage:@"btn_sound_play.png" target:nil selector:nil] retain];
        _minusItem = [[CCMenuItemImage itemWithNormalImage:@"btn_sound_stop.png" 
                                             selectedImage:@"btn_sound_stop.png" target:nil selector:nil] retain];
        //
        CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self 
                                                               selector:@selector(onSoundPlay:) items:_plusItem, _minusItem, nil];
        CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
        toggleMenu.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:toggleMenu z:999];
    }
    //Preload staff
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"njq_sound_01.mp3"];
    //
    return self;
}

//Animation handler
- (void) onAnimation:(id)sender
{
    CCNode* myNodeGraph = [CCBReader nodeGraphFromFile:@"Sleepless01.ccbi"];
    animationManager = myNodeGraph.userObject;
    //    [animationManager runAnimationsForSequenceNamed:@"timeline_wolf"];
    [animationManager runAnimationsForSequenceNamed:@"timeline_wolf" tweenDuration:0.5f];
}
// When pressing the back button, the currently running scene
// is replaced by the start scene, created by CocosBuilder.
- (void) onNext:(id)sender
{
    //NSLog(@"level:%i",[SubjectsModel getLevel]);
	int currentLevel = [SubjectsModel getLevel];
	if (currentLevel<MAX_NUM_CBOOK_STRIPS) {
		currentLevel++;//level stepper ++
		[SubjectsModel setLevel:currentLevel];
		NSLog(@"level:%i",[SubjectsModel getLevel]);
		//    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:@"Sleepless01.ccbi"] withColor:ccc3(0, 0, 0)]];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:CCBI_NAME] backwards:NO]];
	}
}
- (void) onPrevious:(id)sender
{
    //NSLog(@"level:%i",[SubjectsModel getLevel]);
	int currentLevel = [SubjectsModel getLevel];
	if (currentLevel>1) {
		currentLevel--;//level stepper --
		[SubjectsModel setLevel:currentLevel];
		NSLog(@"level:%i",[SubjectsModel getLevel]);
        //ccbi name split-joint
        NSString *levelStr = [NSString stringWithFormat:@"%d", currentLevel];
        NSMutableString *ccbiName = [NSMutableString stringWithString:levelStr];
        [ccbiName appendString:COMIC_BOOK_STRIP_SUFFIX];
		//
		//    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:@"Sleepless01.ccbi"] withColor:ccc3(0, 0, 0)]];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:CCBI_NAME] backwards:YES]];
	}
    
    
}
//Play or pause sound effect
//- (void) onSound:(id)sender
- (void) onSoundPlay:(id)sender
{
    if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"njq_sound_01.mp3" loop:YES];
    }else {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    }
    //
    [btn_sound_stop setVisible:YES];
    [btn_sound_play setVisible:NO];
}
- (void) onSoundStop:(id)sender
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    //
    [btn_sound_stop setVisible:NO];
    [btn_sound_play setVisible:YES];
}
- (void) onSoundPause:(id)sender
{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

//Return home menu
- (void) onHome:(id)sender
{
    //TODO:
}

//
-(void)dealloc
{
    [backgroundSprite release];
    [animationManager release];
    [btn_sound_play release];
    [btn_sound_stop release];
    backgroundSprite = nil;
    animationManager = nil;
    btn_sound_play = nil;
    btn_sound_stop = nil;
    //
    [super dealloc];
}

@end
