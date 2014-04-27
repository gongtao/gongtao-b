//
//  BMDeclarationViewController.m
//  BananaNews
//
//  Created by 曼瑜 朱 on 14-4-27.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "BMDeclarationViewController.h"

@interface BMDeclarationViewController ()

@end

@implementation BMDeclarationViewController

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
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, y, self.view.bounds.size.width, self.view.bounds.size.height-y)];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.showsVerticalScrollIndicator=NO;
    bgView.clipsToBounds=YES;
    [self.view addSubview:bgView];
    
    UILabel * labelAbout = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    //必须是这组值,这个frame是初设的，没关系，后面还会重新设置其size。
    [labelAbout setNumberOfLines:0];  //必须是这组值
    
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(280,NSIntegerMax);
    NSString *newContent=@"  任何用户在使用芝麻短片客户端服务之前，均应仔细阅读本声明（未成年人应当在其法定监护人陪同下阅读），用户可选择不使用芝麻短片客户端服务，一旦使用，即被视为对本声明全部内容的认可和接受。\
    1、任何通过芝麻短片显示或下载的资源和产品均系聚合引擎技术自动搜录第三方网站所有者制作或提供的内容，芝麻短片中的所有材料、信息和产品仅按原样提供，我公司对其合法性、准确性、真实性、适用性、安全性等概不负责，也无法负责；且芝麻短片自动搜录的内容不代表我公司之任何意见和主张，也不表示我公司同意或支持第三方网站上的任何内容、主张或立场。\
    2、任何第三方网站如果不希望被我公司的聚合引擎技术收录，应该及时向我公司反映。否则，我公司的聚合引擎技术将视其为可收录的资源网站。\
    3、任何单位或个人如认为芝麻短片客户端聚合引擎技术收录的第三方网站视频内容可能侵犯了其合法权益，请及时向我公司进行反馈，并提供身份证明、权属证明及详细侵权情况证明。邮件地址：croxch@163.com 。我公司在收到上述邮件后，可依其合理判断，断开聚合引擎技术收录的涉嫌侵权的第三方网站内容。\
    4、用户理解并同意，用户通过芝麻短片所获得的材料、信息、产品及服务完全出于用户自己的判断，并承担因使用该等内容而起的所有风险，包括但不限于因对内容的正确性、完整性或实用性的依赖而产生的风险。用户在使用芝麻短片过程中，因受视频或相内容误导或欺骗而导致或可能导致的任何心理、生理上的伤害以及经济上的损失，一概与我公司无关。\
    5、用户因第三方如电信部门的通讯线路故障、技术问题、网络、电脑故障、系统不稳定性及其他各种不可抗力原因而遭受的一切损失，我公司不承担责任。因技术故障等不可抗事件影响到服务的正常运行的，我公司承诺在第一时间内与相关单位配合，及时处理进行修复，但用户因此而遭受的一切损失，我公司不承担责任。如果您认为芝麻短片内容侵犯了您的相关权益的，请您向芝麻短片发出权利通知，我们将根据相关法律规定采取措施删除相关内容，您以向芝麻短片所设立的专门接受版权投诉和侵权通知的邮箱发送通知书。";
    
    CGSize labelsize = [newContent boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    //UILineBreakModeWordWrap:以空格为界,保留整个单词
    labelAbout.frame = CGRectMake(20, 30, 280, labelsize.height );
    bgView.contentSize=CGSizeMake(self.view.bounds.size.width, labelsize.height+50);
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
