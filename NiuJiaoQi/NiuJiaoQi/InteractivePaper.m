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
@synthesize layer_menuItems;

//Constants
#define COMIC_BOOK_STRIP_SUFFIX @" 副本.png"
#define MAX_NUM_CBOOK_STRIPS 16
#define CCBI_NAME @"InteractivePaper.ccbi"
#define CCBI_SOUND_PREFIX @"njq_sound_"
#define CCBI_SOUND_SUFFIX @".mp3"
#define MC_SUFFIX_PLIST @".plist"
#define MC_SUFFIX_PNG @".png"
#define MC_INFIX_PLIST @"000"

//Variables
CGSize winSize;

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
        winSize = [[CCDirector sharedDirector] winSize];
        anewBG.position = ccp(winSize.width/2,winSize.height/2);
        //Animations assemble
        NSMutableArray *fileNames = [NSMutableArray arrayWithObjects:
                              @"njq_s1_mc_fox", 
                              @"njq_s1_mc_pig", 
                              @"njq_s1_mc_bear", 
                              @"njq_s1_mc_text", 
                              nil];
        [self assembleAnimations:fileNames];

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
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    //
    [super dealloc];
}

-(void)assembleAnimations:(NSMutableArray *)fileNames
{
    int count,i;
    count = [fileNames count];
    //
    for (i = 0; i < count; i++)
    {
        NSLog (@"fileNames %i = %@", i, [fileNames objectAtIndex: i]);
        CCSprite *_bear;
        CCAction *_walkAction;
        // This loads an image of the same name (but ending in png), and goes through the
        // plist to add definitions of each frame to the cache.
        NSString *fileNamePlist = [[NSString alloc] initWithString:[fileNames objectAtIndex: i]];
        fileNamePlist = [fileNamePlist stringByAppendingString:MC_SUFFIX_PLIST];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileNamePlist];        
        
        // Create a sprite sheet with the Happy Bear images
        NSString *fileNamePNG = [[NSString alloc] initWithString:[fileNames objectAtIndex: i]];
        fileNamePNG = [fileNamePNG stringByAppendingString:MC_SUFFIX_PNG];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:fileNamePNG];
        [self addChild:spriteSheet];
        
        // Load up the frames of our animation
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int j = 0; j <= 9; ++j) {
            NSString *frameName = [[NSString alloc] initWithString:[fileNames objectAtIndex: i]];
            frameName = [frameName stringByAppendingString:MC_INFIX_PLIST];
            //
            [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%d", frameName,j]]];
        }
        CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
        
        // Create a sprite for our bear,default index to 0
        NSString *defaultFrameName = [[NSString alloc] initWithString:[fileNames objectAtIndex: i]];
        defaultFrameName = [defaultFrameName stringByAppendingString:MC_INFIX_PLIST];
        defaultFrameName = [defaultFrameName stringByAppendingString:@"0"];
        //
        _bear = [CCSprite spriteWithSpriteFrameName:defaultFrameName];        
        _bear.position = ccp(winSize.width/2, winSize.height/2);
        _walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        [_bear runAction:_walkAction];
        [spriteSheet addChild:_bear];

    }
        
}
@end
