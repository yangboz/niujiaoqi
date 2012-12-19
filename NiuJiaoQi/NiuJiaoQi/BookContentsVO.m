//
//  BookContentsVO.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-18.
//  Copyright (c) 2012年 godpaper. All rights reserved.
//

#import "BookContentsVO.h"
#import "PageContentVO.h"

@implementation BookContentsVO

@synthesize contents;

+ (Class)contents_class {
    return [PageContentVO class];
}

@end
