//
//  HomeLayer.h
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-21.
//  Copyright 2012年 godpaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HomeLayer : CCLayer {
    
}
//Menu handler
- (void) onChinese:(id)sender;
- (void) onEnglish:(id)sender;
- (void) onStart:(id)sender;
- (void) onSleeping:(id)sender;
@end
