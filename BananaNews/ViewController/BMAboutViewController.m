//
//  BMAboutViewController.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMAboutViewController.h"

#define kBottomBarHeight    44.0

@interface BMAboutViewController ()

@end

@implementation BMAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.customNavigationTitle.text = self.title;
    CGFloat y = CGRectGetMaxY(self.customNavigationBar.frame);
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, y, self.view.bounds.size.width, self.view.bounds.size.height-y-kBottomBarHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    bgView.showsVerticalScrollIndicator=NO;
    bgView.clipsToBounds=YES;

    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(60.0, 50.0, 185, 55)];
    imageView.image=[UIImage imageNamed:@"关于_logo.png"];
    [bgView addSubview:imageView];
    
    UILabel * labelAbout = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //必须是这组值,这个frame是初设的，没关系，后面还会重新设置其size。
    [labelAbout setNumberOfLines:0];  //必须是这组值
    
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(259,NSIntegerMax);
    NSString *newContent=@"      “芝麻短片”的团队是一支拥有丰富创业及成熟公司经验的靠谱团队，聚集了来自一流学校和一流公司的顶尖人才，信奉lean startup精益创业，热爱geek文化，我们相信移动短视频分发是Next Big Thing ，团队专注自己擅长的挖掘和制作有意思的小短片，期望成为中国最大的移动短视频分发平台；我们有丰富的内容运营经验和强大的微博微信推广资源。有白富美，无土肥圆，有梦想有激情，对产品充满爱。已经获得创新工场的投资！“芝麻短片”的口号：每天三分钟，生活更轻松！";
    CGSize labelsize = [newContent boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    //UILineBreakModeWordWrap:以空格为界,保留整个单词
    labelAbout.frame = CGRectMake(36, 134, 259, labelsize.height );
    bgView.contentSize=CGSizeMake(self.view.bounds.size.width, labelsize.height+50);
    //_labelContent.backgroundColor = [UIColor colorWithHexString:@"f0f4f7"];
    labelAbout.backgroundColor=[UIColor clearColor];
    labelAbout.textColor = [UIColor blackColor];
    labelAbout.text = newContent;
    labelAbout.font = font;
    [bgView addSubview:labelAbout];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
