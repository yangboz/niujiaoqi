//
//  InteractivePaper.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-14.
//  Copyright 2012年 godpaper. All rights reserved.
//

#import "InteractivePaper.h"
#import "SubjectsModel.h"
#import "CCTouchableSprite.h"

//#define BUTTON_SOUND_CURL @"njq_sound_curl.mp3"
#define BUTTON_SOUND_CURL_NEXT @"njq_sound_curl_next.mp3"
#define BUTTON_SOUND_CURL_PREV @"njq_sound_curl_prev.mp3"
#define BUTTON_SOUND_TOUCH_DEFAULT @"njq_sound_touch_default.mp3"

@implementation InteractivePaper

@synthesize backgroundSprite;
@synthesize animationManager;
@synthesize btn_sound_play,btn_sound_stop,btn_curl_next,btn_curl_prev;
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
//        NSLog(@"BookContentsVO => %@\n", bookContents);
        //Currently,assets prepared 3 pages.
        if(pageIndex<[[bookMetadata strips] intValue])
        {
            //
            pageContent = (PageContentVO *)[[bookContents contents] objectAtIndex:pageIndex];
            //Display page elments(text,movieclip)
            if([pageContent background]!=NULL)
            {
                [self displayPageSprite:pageIndex element:[pageContent background]];
            }
            if ([[pageContent movieclips] count]) {
                [self displayPageMovieclips:pageIndex elements:[pageContent movieclips]];
            }
            if ([[pageContent texts] count]) {
                [self displayPageTexts:pageIndex elements:[pageContent texts]];
            }
            //Play background sound
            if([pageContent sound]!=NULL)
            {
                [self preloadPageElements:pageIndex sound:[pageContent sound]];
            }
            //Preload sound effect
            [[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_SOUND_CURL_NEXT];
            [[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_SOUND_CURL_PREV];
            [[SimpleAudioEngine sharedEngine] preloadEffect:BUTTON_SOUND_TOUCH_DEFAULT];
            //Disable curl buttons
            // -10 means that the update method of this node will be called before other update methods which priority number is higher
            [self scheduleUpdateWithPriority:-10];
            //
            [[CCDirector sharedDirector] purgeCachedData];
            
        }
    }
    //Touch trigger,@see: http://www.cocos2d-iphone.org/forum/topic/73124
//    [self setTouchEnabled:YES];
    
    return self;
}

-(void) update:(ccTime)deltaTime
{
    // update your node here
    // DON'T draw it, JUST update it.
    int currentLevel = [SubjectsModel getLevel];
    if (currentLevel==MAX_NUM_CBOOK_STRIPS) {
        btn_curl_next.isEnabled = NO;
    }
    if (currentLevel==1) {
        btn_curl_prev.isEnabled = NO;
    }
    
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
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_CURL_NEXT];//Play sound effect.
    //NSLog(@"level:%i",[SubjectsModel getLevel]);
	int currentLevel = [SubjectsModel getLevel];
	if (currentLevel<MAX_NUM_CBOOK_STRIPS) {
		currentLevel++;//level stepper ++
		[SubjectsModel setLevel:currentLevel];
		NSLog(@"level:%i",[SubjectsModel getLevel]);
		//    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:@"Sleepless01.ccbi"] withColor:ccc3(0, 0, 0)]];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.2f scene:[CCBReader sceneWithNodeGraphFromFile:CCBI_NAME] backwards:NO]];
	}
}
- (void) onPrevious:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:BUTTON_SOUND_CURL_PREV];//Play sound effect.
    //NSLog(@"level:%i",[SubjectsModel getLevel]);
	int currentLevel = [SubjectsModel getLevel];
	if (currentLevel>1) {
		currentLevel--;//level stepper --
		[SubjectsModel setLevel:currentLevel];
		NSLog(@"level:%i",[SubjectsModel getLevel]);
		//
		//    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCBReader sceneWithNodeGraphFromFile:@"Sleepless01.ccbi"] withColor:ccc3(0, 0, 0)]];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.2f scene:[CCBReader sceneWithNodeGraphFromFile:CCBI_NAME] backwards:YES]];
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
//    [backgroundSprite release];
    [animationManager release];
    [btn_sound_play release];
    [btn_sound_stop release];
//    [btn_curl_next release];
//    [btn_curl_prev release];
    //
    backgroundSprite = nil;
    animationManager = nil;
    btn_sound_play = nil;
    btn_sound_stop = nil;
    btn_curl_next = nil;
    btn_curl_prev = nil;
    //
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    //unschedule
    [self unscheduleUpdate];
    //
    [[SimpleAudioEngine sharedEngine] unloadEffect:BUTTON_SOUND_CURL_NEXT];
    [[SimpleAudioEngine sharedEngine] unloadEffect:BUTTON_SOUND_CURL_PREV];
    [[SimpleAudioEngine sharedEngine] unloadEffect:BUTTON_SOUND_TOUCH_DEFAULT];
    //unregisterWithTouchDispatcher
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    //
    [super dealloc];
}
//
-(void)onExit
{
    //@see:http://www.cocos2d-iphone.org/forum/topic/5354
    [super onExit];
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
}

-(void)displayPageSprite:(int)pageIndex element:(NSString *)background
{
    //Update background sprite
    //        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:bgFileName];
    //        [self.backgroundSprite setTexture: tex];
    //        [self removeChild:backgroundSprite];
    //Anew background to overlay
    backgroundSprite = [CCSprite spriteWithFile:background];
    [self addChild:backgroundSprite];
    winSize = [[CCDirector sharedDirector] winSize];
    backgroundSprite.position = ccp(winSize.width/2,winSize.height/2);
}

-(void)preloadPageElements:(int)pageIndex sound:(NSString *)sound
{
    //Preload staff
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:sound];
}

-(void)displayPageTexts:(int)pageIndex elements:(NSArray *)elements
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
//        CCSprite *_bear;
        CCTouchableSprite *_bear;
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
        _bear = [CCTouchableSprite spriteWithSpriteFrameName:defaultFrameName];
//        _bear = [CCSprite spriteWithSpriteFrameName:defaultFrameName];
        _bear.position = ccp(mcX, mcY);
//        _walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
//        _walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        _walkAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walkAnim] times:1];
        [_bear runAction:_walkAction];
        
        //
        [spriteSheet addChild:_bear];
        //
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: fileNamePlist];
//        [[CCTextureCache sharedTextureCache] removeTextureForKey: fileNamePNG];
    }        
}

-(void)displayPageMovieclips:(int)pageIndex elements:(NSArray *)elements
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
        CCTouchableSprite *_bear;
//        CCSprite *_bear;
        CCAction *_walkAction;
        // This loads an image of the same name (but ending in png), and goes through the
        // plist to add definitions of each frame to the cache.
        NSString *fileNamePlist = [textureFileName stringByAppendingString:MC_SUFFIX_PLIST];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fileNamePlist];        
        
        // Create a sprite sheet with the Happy Bear images
        NSString *fileNamePNG = [textureFileName stringByAppendingString:textureFileExtension];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:fileNamePNG];
        [self addChild:spriteSheet];
        
        // Sound effect file name
        NSString *soundEffectName = [(PageElementVO *)[elements objectAtIndex: i] soundEffect];
        
        // Load up the frames of our animation
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int j = 0; j < [frames intValue]; ++j) {
            //
            NSString *frameName = [textureFileName stringByAppendingString:[self getTextureFileNameInfix:j]];
            //
            [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f];
//        walkAnim.restoreOriginalFrame = YES;
        
        // Create a sprite for our MC,default index to 0
        NSString *defaultFrameName = [textureFileName stringByAppendingString:[self getTextureFileNameInfix:0]];
        //
        _bear = [CCTouchableSprite spriteWithSpriteFrameName:defaultFrameName]; 
//        _bear = [CCSprite spriteWithSpriteFrameName:defaultFrameName]; 
        _bear.position = ccp(mcX, mcY);
        //        _walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
//        _walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim] ];
         _walkAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walkAnim] times:1];
        //        [_bear runAction:_walkAction];
        //Movieclip run ation with touch trigger.
        _bear.isTouchEnabled = NO;
//        //@see: http://stackoverflow.com/questions/7198695/runaction-animation-crash-problem-whats-missing
//        [_bear setTouchBlock:^(CCTouchableSprite *sprite) {
//             CCTouchableSprite __weak *weakBear = _bear;
//             CCAction __weak *weakWalkAction = _walkAction;
//            
//            [weakBear stopAction:weakWalkAction];
////            [[SimpleAudioEngine sharedEngine] playEffect:soundEffectName];//Play sound effect.
//            [weakBear runAction:weakWalkAction];
//        }];
//        [_bear setTouchTarget:self action:@selector(onAnimation:)];
        //
        [spriteSheet addChild:_bear];
        //
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: fileNamePlist];
        //        [[CCTextureCache sharedTextureCache] removeTextureForKey: fileNamePNG];
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


// Add these new methods
-(void) registerWithTouchDispatcher
{
//    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 
//                                              swallowsTouches:YES];
    //@see: http://www.iphonewarroom.com/2011/03/cocos2d-how-to-pass-touch-event-to.html
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:NO];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {   
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {    
    // Animations control staff.
//    NSLog(@"Touch target:%@",(CCSprite *)[touch.view]);
    
}


@end
