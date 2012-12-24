//
//  CCTargetedTouchDelegate.h
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-24.
//  Copyright (c) 2012年 godpaper. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCTargetedTouchDelegate
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
@optional 
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;
@end
