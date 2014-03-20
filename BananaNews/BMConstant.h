//
//  BMConstant.h
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#ifndef BananaNews_BMConstant_h
#define BananaNews_BMConstant_h

#define kAppKey     @"52cc8b8a56240b6c8c023b74"

#define kWXAppKey   @"wx0a4285548e1b5eb2"

#define kLoginKey   @"isLogin"

#define kLoginToken @"loginToken"

#define kLoginSuccessNotification   @"LoginSuccessNotification"

#define PlayAppsVideoNotification   @"PlayAppsVideoNotification"

#define kBaseURL    [NSURL URLWithString:@"http://xiangjiaoribao.com"]

//#define kBaseURL    [NSURL URLWithString:@"http://115.29.43.107/site/"]

#define IS_IOS7     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define IS_IPhone5_or_5s    ([UIScreen mainScreen].bounds.size.width == 568.0)

#define Color_NavBarBg              [UIColor colorWithHexString:@"82ce24"]
#define Color_ViewBg                [UIColor colorWithHexString:@"f3f3f3"]

//1.0版本数据
#define kSidePanelLeftWidth     232.0
#define kSidePanelRightWidth    220.0

#define kCellSingleImgWidth     296.0
#define kCellSingleImgHeight    180.0

#define kCellMediumImgWidth     130.0
#define kCellMediumImgHeight    85.0

#define kCellSmallImgWidth      96.0
#define kCellSmallImgHeight     56.0

#define Font_NewsTitle      [UIFont systemFontOfSize:14.0]
#define Font_NewsSmall      [UIFont systemFontOfSize:10.0]

#define Color_Yellow        [UIColor colorWithHexString:@"ebdb01"]
#define Color_GrayLine      [UIColor colorWithHexString:@"dcdcdc"]
#define Color_CellBg        [UIColor colorWithHexString:@"e4e4df"]
#define Color_SideBg        [UIColor colorWithHexString:@"f3f3f3"]
#define Color_DetalInputBg  [UIColor colorWithHexString:@"ccecece7"]
#define Color_ContentBg     [UIColor colorWithHexString:@"f7f7f7"]
#define Color_TabBar        [UIColor colorWithHexString:@"ecece7"]
#define Color_TabBarSelect  [UIColor colorWithHexString:@"e4e4e4"]
#define Color_SideFont      [UIColor colorWithHexString:@"666666"]
#define Color_GrayFont      [UIColor colorWithHexString:@"c6c6c6"]
#define Color_NewsFont      [UIColor colorWithHexString:@"333333"]
#define Color_NewsSmallFont [UIColor colorWithHexString:@"999999"]
#define Color_CommentUser   [UIColor colorWithHexString:@"348ad2"]
#define Color_UploadFrameBg [UIColor colorWithHexString:@"f9f9f9"]


#endif
