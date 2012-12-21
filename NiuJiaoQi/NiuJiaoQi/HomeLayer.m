//
//  HomeLayer.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-21.
//  Copyright 2012年 godpaper. All rights reserved.
//

#import "HomeLayer.h"
#import "CCBReader.h"

@implementation HomeLayer

- (void) onChinese:(id)sender
{
    
}
- (void) onEnglish:(id)sender
{
    
}
- (void) onStart:(id)sender
{
    //Scene transition
    CCLayer *layer = (CCLayer *) [CCBReader nodeGraphFromFile:@"InteractivePaper.ccbi"];
    
    //        layer.isTouchEnabled = YES;
    
    CCScene *scene = [CCScene node];
    [scene addChild:layer];
    //    [[CCDirector sharedDirector] runWithScene: scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];
}
- (void) onSleeping:(id)sender
{
    
}
@end
