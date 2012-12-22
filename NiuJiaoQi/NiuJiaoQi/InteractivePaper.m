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
#define MAX_NUM_CBOOK_STRIPS 16
#define CCBI_NAME @"InteractivePaper.ccbi"
#define CCBI_SOUND_SUFFIX @".mp3"
#define MC_SUFFIX_PLIST @".plist"
#define MC_SUFFIX_PNG @".png"
#define MC_INFIX @"000"

//Variables
CGSize winSize;
PageContentVO *pageContent;

-(id) init
{
	if ((self=[super init])) {
        //Page elements(text,button,sprite,movieclip...) display
        int pageIndex = [SubjectsModel getLevel]-1;//Notice:page index 0 based.
        BookContentsVO *bookContents = [SubjectsModel getContents];
        BookMetadataVO *bookMetadata = [SubjectsModel getMetadata];
        NSLog(@"BookContentsVO => %@\n", bookContents);
        //Currently,assets prepared 3 pages.
        if(pageIndex<[[bookMetadata strips] intValue])
        {
            //
            pageContent = (PageContentVO *)[[bookContents contents] objectAtIndex:pageIndex];
            //
            if([pageContent background]!=NULL)
            {
                [self displayPageElements:pageIndex background:[pageContent background]];
            }
            if ([[pageContent movieclips] count]) {
                [self displayPageElements:pageIndex elements:[pageContent movieclips]];
            }
            if ([[pageContent texts] count]) {
                [self displayPageElements:pageIndex elements:[pageContent texts]];
            }
            //
            if([pageContent sound]!=NULL)
            {
                [self preloadPageElements:pageIndex sound:[pageContent sound]];
            }
        }
    }
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
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[pageContent sound] loop:YES];
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
    //Scene transition
    CCLayer *layer = (CCLayer *) [CCBReader nodeGraphFromFile:@"HomeLayer.ccbi"];
    
    //        layer.isTouchEnabled = YES;
    
    CCScene *scene = [CCScene node];
    [scene addChild:layer];
    //    [[CCDirector sharedDirector] runWithScene: scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];
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

-(void)displayPageElements:(int)pageIndex background:(NSString *)background
{
    //Update background sprite
    //        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:bgFileName];
    //        [self.backgroundSprite setTexture: tex];
    //        [self removeChild:backgroundSprite];
    //Anew background to overlay
    CCSprite *anewBG = [CCSprite spriteWithFile:background];
    [self addChild:anewBG];
    winSize = [[CCDirector sharedDirector] winSize];
    anewBG.position = ccp(winSize.width/2,winSize.height/2);
}

-(void)preloadPageElements:(int)pageIndex sound:(NSString *)sound
{
    //Preload staff
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:sound];
}

-(void)displayPageElements:(int)pageIndex elements:(NSArray *)elements
{
    //@see:http://www.raywenderlich.com/1271/how-to-use-animations-and-sprite-sheets-in-cocos2d
    //
    int mcCount,i;
    //Movie clip counter
    mcCount = [elements count];
    NSLog(@"PageMC:%@",[[elements objectAtIndex:0] textureFileName]);
    NSString *textureFileName;
    //For MC
    for (i = 0; i < mcCount; i++)
    {
        textureFileName = [(PageElementVO *)[elements objectAtIndex: i] textureFileName];
        NSString *textureFileExtension = [(PageElementVO *)[elements objectAtIndex: i] textureFileExtension];
        NSNumber *frames = [(PageElementVO *)[elements objectAtIndex: i] frames];
        int mcX = [[(PageElementVO *)[elements objectAtIndex: i] x] intValue];
        int mcY = 768 - [[(PageElementVO *)[elements objectAtIndex: i] y] intValue];
        NSLog (@"movieclip info %i = %@,%@,%d,%d", i, textureFileName,textureFileExtension,mcX,mcY);
        //MovieClip assemble(bear for example)
        CCSprite *_bear;
        CCAction *_walkAction;
        // This loads an image of the same name (but ending in png), and goes through the
        // plist to add definitions of each frame to the cache.
        NSString *fileNamePlist = [textureFileName stringByAppendingString:MC_SUFFIX_PLIST];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileNamePlist];        
        
        // Create a sprite sheet with the Happy Bear images
        NSString *fileNamePNG = [textureFileName stringByAppendingString:textureFileExtension];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:fileNamePNG];
        [self addChild:spriteSheet];
        
        // Load up the frames of our animation
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int j = 0; j < [frames intValue]; ++j) {
            //
            NSString *frameName = [textureFileName stringByAppendingString:[self getTextureFileNameInfix:j]];
            //
            [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f];
        
        // Create a sprite for our MC,default index to 0
        NSString *defaultFrameName = [textureFileName stringByAppendingString:[self getTextureFileNameInfix:0]];
        //
        _bear = [CCSprite spriteWithSpriteFrameName:defaultFrameName];        
        _bear.position = ccp(mcX, mcY);
//        _walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        _walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        [_bear runAction:_walkAction];
        [spriteSheet addChild:_bear];
        //
        _bear = nil;
        _walkAction = nil;
        spriteSheet = nil;
        
    }        
}

-(NSString *)getTextureFileNameInfix:(int)frameIndex
{
    NSString *infix = MC_INFIX;
    if(frameIndex>=10)
    {
        infix = @"00";
    }
    if(frameIndex>=100)
    {
        infix = @"0";
    }
    return [infix stringByAppendingFormat:@"%d",frameIndex];
}
@end
