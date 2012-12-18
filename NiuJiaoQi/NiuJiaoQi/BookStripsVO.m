//
//  BookStripsVO.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-18.
//  Copyright (c) 2012年 godpaper. All rights reserved.
//

#import "BookStripsVO.h"
#import "BookContentsVO.h"

@implementation BookStripsVO

@synthesize metadata,contents;

+ (Class)contents_class {
    return [BookContentsVO class];
}

@end
