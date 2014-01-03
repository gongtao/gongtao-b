//
//  BMConstant.h
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#ifndef BananaNews_BMConstant_h
#define BananaNews_BMConstant_h

#define kBaseURL [NSURL URLWithString:@"http://115.29.43.107/site/wp_api/v1"]

#define kSidePanelLeftWidth     232.0
#define kSidePanelRightWidth    220.0

#define IS_IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)

#define Font_NewsTitle      [UIFont systemFontOfSize:14.0]
#define Font_NewsSmall      [UIFont systemFontOfSize:10.0]

#define Color_Yellow        [UIColor colorWithHexString:@"ebdb01"]
#define Color_GrayLine      [UIColor colorWithHexString:@"dcdcdc"]
#define Color_CellBg        [UIColor colorWithHexString:@"e4e4df"]
#define Color_SideBg        [UIColor colorWithHexString:@"f3f3f3"]
#define Color_ContentBg     [UIColor colorWithHexString:@"f7f7f7"]
#define Color_SideFont      [UIColor colorWithHexString:@"666666"]
#define Color_GrayFont      [UIColor colorWithHexString:@"c6c6c6"]
#define Color_NewsFont      [UIColor colorWithHexString:@"333333"]
#define Color_NewsSmallFont [UIColor colorWithHexString:@"999999"]

#endif
