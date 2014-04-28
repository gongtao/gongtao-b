//
//  BMCommentViewController.m
//  BananaNews
//
//  Created by 龚涛 on 3/24/14.
//  Copyright (c) 2014 龚涛. All rights reserved.
//

#import "BMCommentViewController.h"

#import "BMCommentTableViewController.h"

#import "BMCustomButton.h"

#import "BMUtils.h"

@interface BMCommentViewController ()

@property (nonatomic, strong) Comment *replyComment;

@property (nonatomic, strong) UIImageView *inputView;

@property (nonatomic, strong) BMCustomButton *sendButton;

@property (nonatomic, strong) UITextField *textView;

@property (nonatomic, strong) BMCommentTableViewController *commentVC;

- (void)_cancel:(UIButton *)button;

@end

@implementation BMCommentViewController

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
    self.view.backgroundColor = Color_ViewBg;
    
    CGFloat y = IS_IOS7?64.0:44.0;
    
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, y)];
    navigationBar.backgroundColor = Color_CommentBlue;
    [self.view addSubview:navigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, y-44.0, self.view.frame.size.width, 44.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"评论";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    
    BMCustomButton *button = [[BMCustomButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-44.0, y-44.0, 44.0, 44.0)];
    button.imageRect = CGRectMake(14.0, 14.0, 15.0, 15.0);
    [button setImage:[UIImage imageNamed:@"评论界面取消.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"评论界面取消高亮.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(_cancel:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:button];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:Comment_Entity inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDesciptor = [NSSortDescriptor sortDescriptorWithKey:kCommentDate ascending:NO];
    request.predicate = [NSPredicate predicateWithFormat:@"news.nid == %@",_news.nid];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesciptor]];

    _commentVC = [[BMCommentTableViewController alloc] initWithRequest:request cacheName:@"cacheCommentData"];
    _commentVC.view.frame=CGRectMake(0.0, y, self.view.bounds.size.width, self.view.bounds.size.height-y-49.0);
    _commentVC.tableView.frame=CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height-y-49.0);
    _commentVC.news = _news;
    _commentVC.delegate = self;
    [self addChildViewController:_commentVC];
    [self.view addSubview:_commentVC.view];
    [_commentVC startLoadingTableViewData];
    
    _inputView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-49.0, self.view.frame.size.width, 49.0)];
    _inputView.image = [UIImage imageNamed:@"评论框.png"];
    _inputView.userInteractionEnabled = YES;
    [self.view addSubview:_inputView];
    
    _textView = [[UITextField alloc] initWithFrame:CGRectMake(17.0, 15.0, 230.0, 20.0)];
    _textView.font = [UIFont systemFontOfSize:12.0];
    _textView.placeholder = @"评论";
    _textView.delegate = self;
    [_inputView addSubview:_textView];
    
    _sendButton = [[BMCustomButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-67.0, 12.0, 67.0, 25.0)];
    _sendButton.imageRect = CGRectMake(17.0, 5.0, 33.0, 15.0);
    [_sendButton setImage:[UIImage imageNamed:@"评论界面发送.png"] forState:UIControlStateNormal];
    [_sendButton setImage:[UIImage imageNamed:@"评论界面发送高亮.png"] forState:UIControlStateHighlighted];
    [_sendButton addTarget:self action:@selector(_send:) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:_sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - Private

- (void)_cancel:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didCancelCommentViewController)]) {
        [self.delegate didCancelCommentViewController];
    }
}

- (void)_send:(id)sender
{
    NSLog(@"send");
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kLoginKey]) {
        [_textView resignFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论" message:@"亲~请先登录再评论" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"登录", nil];
        [alertView show];
        return;
    }
    
    NSString *comment = _textView.text;
    if (self.replyComment) {
        comment = [comment stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"回复%@：", self.replyComment.author.name] withString:@""];
    }
    if (!comment || comment.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论" message:@"请输入评论内容" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [[BMNewsManager sharedManager] postComment:self.news.nid.integerValue
                                       comment:comment
                                  replyComment:self.replyComment
                                       success:^(void){
                                           self.replyComment = nil;
                                           self.textView.text = @"";
                                           [BMUtils showToast:@"评论成功，等待审核"];
                                       }
                                       failure:^(NSError *error){
                                           [BMUtils showErrorToast:@"评论失败"];
                                       }];
    
    [self _cancelInput:nil];
}

- (void)_cancelInput:(id)sender
{
    [_textView resignFirstResponder];
}

- (void)_keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat keyY = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat y = IS_IOS7?64.0:44.0;
        _commentVC.view.frame = CGRectMake(0.0, y, self.view.frame.size.width, keyY-y-49.0);
        _commentVC.tableView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, keyY-y-49.0);
        _inputView.frame = CGRectMake(0.0, CGRectGetMaxY(_commentVC.view.frame), self.view.frame.size.width, 49.0);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
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
        [_textView resignFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评论" message:@"亲~请先登录再评论" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"登录", nil];
        [alertView show];
        return;
    }
    
    [_textView becomeFirstResponder];
}

@end
