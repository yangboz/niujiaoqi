//
//  BookStripsVO.h
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-18.
//  Copyright (c) 2012年 godpaper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
#import "BookMetadataVO.h"

@interface BookStripsVO : Jastor

@property (nonatomic, copy) BookMetadataVO *metadata;
@property (nonatomic, retain) NSArray *contents;

@end
