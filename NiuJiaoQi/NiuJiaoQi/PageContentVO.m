//
//  PageContentVO.m
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-18.
//  Copyright (c) 2012年 godpaper. All rights reserved.
//

#import "PageContentVO.h"
#import "PageElementVO.h"

@implementation PageContentVO

@synthesize texts,sprites,buttons,movieclips;


+ (Class)texts_class {
    return [PageElementVO class];
}
+ (Class)sprites_class {
    return [PageElementVO class];
}
+ (Class)buttons_class {
    return [PageElementVO class];
}
+ (Class)movieclips_class {
    return [PageElementVO class];
}

@end
