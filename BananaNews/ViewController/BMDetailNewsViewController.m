//
//  BMDetailNewsViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/31/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMDetailNewsViewController.h"

#import "BMDetailViewController.h"

#import "BMCustomButton.h"

#import "BMUtils.h"

@interface BMDetailNewsViewController ()

@property (nonatomic, strong) Comment *replyComment;

@property (nonatomic, strong) UIControl *inputBgView;

@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *sendButton;

- (void)_comment:(id)sender;

- (void)_collect:(id)sender;

- (void)_share:(id)sender;

- (void)_keyboardWillShow:(NSNotification *)notification;

- (void)_send:(id)sender;

- (void)_cancelInput:(id)sender;

- (void)_loginToSite:(NSNotification *)notice;

@end

@implementation BMDetailNewsViewController

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
    CGFloat y = self.customNavigationBar.frame.size.height;
    BMDetailViewController *vc = [[BMDetailViewController alloc] initWithRequest:self.news];
    vc.delegate = self;
    vc.view.frame = CGRectMake(0.0, y, 320.0, self.view.frame.size.height-y);
    vc.tableView.frame = vc.view.bounds;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    BMCustomButton *button = [[BMCustomButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 45.0, 44.0)];
    button.imageRect = CGRectMake(10.0, 3.0, 25.0, 25.0);
    button.titleRect = CGRectMake(0.0, 24.0, 45.0, 12.0);
    [button setImage:[UIImage imageNamed:@"详情页评论.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"详情页评论.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(_comment:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[NSString stringWithFormat:@"%@", self.news.comment_count] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:9.0];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.customNavigationBar.rightView = button;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-40.0, 320.0, 40.0)];
    bottomView.layer.backgroundColor = Color_DetalInputBg.CGColor;
    [self.view addSubview:bottomView];
    
    UIControl *inputView = [[UIControl alloc] initWithFrame:CGRectMake(6.0, 5.0, 215.0, 30.0)];
    inputView.backgroundColor = [UIColor whiteColor];
    [inputView addTarget:self action:@selector(_comment:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:inputView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 2.5, 25.0, 25.0)];
    imageView.image = [UIImage imageNamed:@"详情页跟帖.png"];
    [inputView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(31.0, 0.0, 50.0, 30.0)];
    label.font = Font_NewsTitle;
    label.textColor = Color_NewsSmallFont;
    label.text = @"爱吐槽";
    label.backgroundColor = [UIColor clearColor];
    [inputView addSubview:label];
    
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(232.0, 0.0, 40.0, 40.0)];
    [collectButton setImage:[UIImage imageNamed:@"详情页收藏.png"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"详情页收藏按下.png"] forState:UIControlStateHighlighted];
    [collectButton addTarget:self action:@selector(_collect:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:collectButton];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(272.0, 0.0, 40.0, 40.0)];
    [shareButton setImage:[UIImage imageNamed:@"详情页分享.png"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"详情页分享按下.png"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(_share:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:shareButton];
    
    _inputBgView = [[UIControl alloc] initWithFrame:self.view.bounds];
    _inputBgView.layer.backgroundColor = [UIColor colorWithHexString:@"99000000"].CGColor;
    [_inputBgView addTarget:self action:@selector(_cancelInput:) forControlEvents:UIControlEventTouchDown];
    _inputBgView.alpha = 0.0;
    [self.view addSubview:_inputBgView];
    
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-140.0, 320.0, 140.0)];
    _inputView.backgroundColor = Color_CellBg;
    [_inputBgView addSubview:_inputView];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 35.0)];
    commentLabel.text = @"爱吐槽";
    commentLabel.textColor = Color_NewsFont;
    commentLabel.textAlignment = NSTextAlignmentCenter;
    [_inputView addSubview:commentLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(6.0, 0.0, 25.0, 35.0)];
    [cancelButton setImage:[UIImage imageNamed:@"详情页关闭.png"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"详情页关闭按下.png"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(_cancelInput:) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:cancelButton];
    
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(289.0, 0.0, 25.0, 35.0)];
    [_sendButton setImage:[UIImage imageNamed:@"详情页确定.png"] forState:UIControlStateNormal];
    [_sendButton setImage:[UIImage imageNamed:@"详情页确定按下.png"] forState:UIControlStateHighlighted];
    [_sendButton setImage:[UIImage imageNamed:@"详情页确定不可点状态.png"] forState:UIControlStateDisabled];
    [_sendButton addTarget:self action:@selector(_send:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.enabled = NO;
    [_inputView addSubview:_sendButton];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(6.0, 35.0, 308.0, 96.0)];
    _textView.delegate = self;
    _textView.font = Font_NewsTitle;
    _textView.textColor = Color_NewsFont;
    [_inputView addSubview:_textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loginToSite:) name:kLoginSuccessNotification object:nil];
    
    [[BMNewsManager sharedManager] getCommentsByNews:self.news page:1 success:nil failure:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loginToSite:(NSNotification *)notice
{
    User *user = notice.userInfo[@"user"];
    if (user) {
        [self _comment:nil];
    }
}

#pragma mark - Private

- (void)_comment:(id)sender
{
    self.replyComment = nil;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论" message:@"亲~请先登录再评论" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"登录", nil];
        [alertView show];
        return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^(void) {
                         _inputBgView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [_textView becomeFirstResponder];
                     }
     ];
}

- (void)_collect:(id)sender
{
    
}

- (void)_share:(id)sender
{
    [[BMNewsManager sharedManager] shareNews:self.news delegate:self];
}

- (void)_keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^(void){
        self.inputView.frame = CGRectMake(0.0, keyboardRect.origin.y-140.0, 320.0, 140.0);
    }];
}

- (void)_send:(id)sender
{
    NSLog(@"send");
    NSString *comment = _textView.text;
    if (self.replyComment) {
        comment = [comment stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"回复%@：", self.replyComment.author.name] withString:@""];
    }
    if (!comment || comment.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"吐槽" message:@"请输入您想吐槽的内容" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [[BMNewsManager sharedManager] postComment:self.news.nid.integerValue
                                       comment:comment
                                  replyComment:self.replyComment
                                       success:^(void){
                                           [BMUtils showToast:@"吐槽成功，等待审核"];
                                       }
                                       failure:^(NSError *error){
                                           [BMUtils showErrorToast:@"吐槽失败"];
                                       }];
    
    [self _cancelInput:nil];
}

- (void)_cancelInput:(id)sender
{
    [_textView resignFirstResponder];
    [UIView animateWithDuration:0.3
                     animations:^(void) {
                         _inputBgView.alpha = 0.0;
                     }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _sendButton.enabled = (textView.text.length>0);
}

#pragma mark - UMSocialUIDelegate

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    [[BMNewsManager sharedManager] shareToSite:self.news.nid.integerValue success:nil failure:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"登录"]) {
        BMSNSLoginView *loginView = [[BMSNSLoginView alloc] initWithFrame:self.view.bounds];
        [loginView showInView:self.view];
    }
}

#pragma mark - BMDetailViewControllerDelegate

- (void)willReplyComment:(Comment *)comment
{
    self.replyComment = comment;
    _textView.text = [NSString stringWithFormat:@"回复%@：", comment.author.name];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论" message:@"亲~请先登录再评论" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"登录", nil];
        [alertView show];
        return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^(void) {
                         _inputBgView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [_textView becomeFirstResponder];
                     }
     ];
}

@end
