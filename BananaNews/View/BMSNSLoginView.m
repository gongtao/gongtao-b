//
//  BMSNSLoginView.m
//  BananaNews
//
//  Created by 龚涛 on 1/14/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMSNSLoginView.h"

#import "BMSNSLoginButton.h"

#import "UMSocial.h"

@interface BMSNSLoginView ()

- (void)selectSNS:(UIControl *)sender;

@end

@implementation BMSNSLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor colorWithHexString:@"99000000"].CGColor;
        
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 183.0, 111.0)];
        _contentView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-20.0);
        _contentView.backgroundColor = Color_GrayLine;
        [self addSubview:_contentView];
        
        BMSNSLoginButton *button1 = [[BMSNSLoginButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 183.0, 55.0)];
        button1.titleLabel.text = @"新浪微博登录";
        [button1 addTarget:self action:@selector(selectSNS:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 0;
        button1.imageView.image = [UIImage imageNamed:@"新浪logo.png"];
        [_contentView addSubview:button1];
        
        BMSNSLoginButton *button2 = [[BMSNSLoginButton alloc] initWithFrame:CGRectMake(0.0, 56.0, 183.0, 55.0)];
        button2.titleLabel.text = @"腾讯QQ登陆";
        [button2 addTarget:self action:@selector(selectSNS:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 1;
        button2.imageView.image = [UIImage imageNamed:@"QQlogo.png"];
        [_contentView addSubview:button2];
        
        self.alpha = 0.0;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(_contentView.frame, point)) {
        
        return YES;
    }
    [self dismiss];
    return NO;
}

#pragma mark - Private

- (void)selectSNS:(UIControl *)sender
{
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                     }];
    self.loginType = UMShareToSina;
    if (1 == sender.tag) {
        self.loginType = UMShareToQQ;
    }
    if ([UMSocialAccountManager isOauthWithPlatform:self.loginType]) {
        [self _loginToSite];
        return;
    }
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:self.loginType];
    snsPlatform.loginClickHandler([UIApplication sharedApplication].keyWindow.rootViewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
        if ([UMSocialAccountManager isOauthWithPlatform:self.loginType]) {
            [self _loginToSite];
        }
        else {
            [self dismiss];
        }
    });
}

- (void)_loginToSite
{
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    UMSocialAccountEntity *account = [snsAccountDic valueForKey:self.loginType];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    if (account.userName) {
        if (account.userName.length>12) {
            param[@"user_login"] = [account.userName substringToIndex:11];
        }
        else {
            param[@"user_login"] = account.userName;
        }
        param[@"display_name"] = account.userName;
    }
    if (account.usid) {
        param[@"unid"] = account.usid;
    }
    if (account.iconURL) {
        param[@"avatar"] = account.iconURL;
    }
    if ([self.loginType isEqualToString:UMShareToSina]) {
        param[@"login_type"] = @"sianweibo";
    }
    else if ([self.loginType isEqualToString:UMShareToQQ]) {
        param[@"login_type"] = @"qqsns";
    }
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:self.loginType completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        NSString *description = response.data[@"description"];
        if (description) {
            param[@"description"] = description;
        }
        //用户登陆http
        [[BMNewsManager sharedManager] userLogin:param
                                         success:^(User *user){
                                             [[NSUserDefaults standardUserDefaults] setObject:self.loginType forKey:kLoginKey];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil userInfo:@{@"user": user}];
                                             [self dismiss];
                                         }
                                         failure:^(NSError *error){
                                             [self dismiss];
                                         }];
    }];
}

#pragma mark - Public

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^(void){
        self.alpha = 1.0;
    }];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end
