//
//  BookMetadataVO.h
//  NiuJiaoQi
//
//  Created by zhou Yangbo on 12-12-18.
//  Copyright (c) 2012年 godpaper. All rights reserved.
//

#import "Jastor.h"

@interface BookMetadataVO : Jastor

@property (nonatomic, copy) NSNumber *format;
@property (nonatomic, copy) NSNumber *strips;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSNumber *fps;

@end
