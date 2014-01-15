//
//  FeedbackViewController.m
//  JikeNews
//
//  Created by changda on 12-12-9.
//  Copyright (c) 2012年 Jike. All rights reserved.
//

#import "BMFeedbackViewController.h"

//#import "JKNewsServerInterface.h"
//#import "ASIFormDataRequest.h"
#import "L_FeedbackTableViewCell.h"
#import "R_FeedbackTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

@interface BMFeedbackViewController ()

@end

@implementation BMFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    feedbackClient.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [feedbackClient get];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGFloat y = CGRectGetMaxY(self.customNavigationBar.frame);
    _feedbackView = [[UIView alloc] initWithFrame:CGRectMake(0.0, y, self.view.bounds.size.width, self.view.bounds.size.height-y)];
    _feedbackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_feedbackView];
    
    self.mToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0., _feedbackView.frame.size.height-44., _feedbackView.frame.size.width, 44.)];
    [self.mToolBar setBackgroundImage:[UIImage imageNamed:@"城市选择背景.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    self.mToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_feedbackView addSubview:self.mToolBar];
    
    UIImageView *editView = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., 232., 32.)];
    editView.image = [UIImage imageNamed:@"反馈输入框.png"];
    editView.userInteractionEnabled = YES;
    UIBarButtonItem *editBtnItem = [[UIBarButtonItem alloc] initWithCustomView:editView];
    self.mTextField = [[UITextField alloc] initWithFrame:CGRectMake(5., 1., 222., 30.)];
    self.mTextField.placeholder = @"亲～求意见^_^";
    self.mTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.mTextField.returnKeyType = UIReturnKeyDone;
    self.mTextField.delegate = self;
    self.mTextField.font = [UIFont systemFontOfSize:15.];
    self.mTextField.textColor = [UIColor colorWithHexString:@"333333"];
    [editView addSubview:self.mTextField];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 57., 31.)];
    [button setImage:[UIImage imageNamed:@"反馈发送.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"反馈发送移上.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(sendFeedback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.mToolBar setItems:@[editBtnItem, doneBtnItem]];
    
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, _feedbackView.frame.size.width, _feedbackView.frame.size.height-44.0)];
    self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.backgroundColor = [UIColor clearColor];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.mTableView.frame.size.width, 5.)];
    footer.backgroundColor = [UIColor clearColor];
    self.mTableView.tableFooterView = footer;
    [_feedbackView addSubview:self.mTableView];
    
    feedbackClient = [UMFeedback sharedInstance];
    [feedbackClient setAppkey:kAppKey delegate:self];
    
    //    从缓存取topicAndReplies
    self.mFeedbackDatas = feedbackClient.topicAndReplies;
    [self updateTableView:nil];
    
    [self.view bringSubviewToFront:self.customNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat y = CGRectGetMaxY(self.customNavigationBar.frame);
        _feedbackView.frame = CGRectMake(0.0, y, self.view.frame.size.width, self.view.frame.size.height-kbSize.height-y);
        if (self.mTableView.contentOffset.y + self.mTableView.frame.size.height < self.mTableView.contentSize.height) {
            self.mTableView.contentOffset = CGPointMake(0.0, self.mTableView.contentSize.height-self.mTableView.frame.size.height);
        }
    }];
}

- (void)sendFeedback
{
    if (self.mTextField.text && [self.mTextField.text length])
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:self.mTextField.text forKey:@"content"];
        
        [feedbackClient post:dictionary];
        [self.mTextField resignFirstResponder];
        
        [UIView animateWithDuration:0.2 animations:^{
            _feedbackView.frame = self.view.bounds;
        }];
        
    }
    else {
        NSLog(@"请输入反馈内容");
    }
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_mFeedbackDatas count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = @"您好，感谢您使用香蕉日报，希望您能留下您的使用感受和宝贵建议，我们会在第一时间给您回复。";
    if (indexPath.row > 0) {
        content = [[self.mFeedbackDatas objectAtIndex:indexPath.row-1] objectForKey:@"content"];
    }
    CGSize labelSize = [content sizeWithFont:Font_NewsTitle
                           constrainedToSize:CGSizeMake(250.0f, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
    
    
    return labelSize.height + 30.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *L_CellIdentifier = @"L_UMFBTableViewCell";
    static NSString *R_CellIdentifier = @"R_UMFBTableViewCell";
    
    if (indexPath.row == 0) {
        L_FeedbackTableViewCell *cell = (L_FeedbackTableViewCell *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil) {
            cell = [[L_FeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }
        
        cell.textLabel.text = @"您好，感谢您使用香蕉日报，希望您能留下您的使用感受和宝贵建议，我们会在第一时间给您回复。";
        
        return cell;
    }
    
    NSDictionary *data = [self.mFeedbackDatas objectAtIndex:indexPath.row-1];
    NSLog(@"%@", data);
    if ([[data valueForKey:@"type"] isEqualToString:@"dev_reply"]) {
        L_FeedbackTableViewCell *cell = (L_FeedbackTableViewCell *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil) {
            cell = [[L_FeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }
        
        cell.textLabel.text = [data valueForKey:@"content"];
        
        return cell;
    }
    else {
        
        R_FeedbackTableViewCell *cell = (R_FeedbackTableViewCell *) [tableView dequeueReusableCellWithIdentifier:R_CellIdentifier];
        if (cell == nil) {
            cell = [[R_FeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:R_CellIdentifier];
        }
        
        cell.textLabel.text = [data valueForKey:@"content"];
        
        return cell;
        
    }
}

#pragma mark Umeng Feedback delegate

- (void)updateTableView:(NSError *)error
{
    if ([self.mFeedbackDatas count]) {
        [self.mTableView reloadData];
        
        int lastRowNumber = [self.mTableView numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.mTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        
    }
    else {
        
    }
}

- (void)updateTextField:(NSError *)error
{
    self.mTextField.text = @"";
    [feedbackClient get];
}

- (void)getFinishedWithError:(NSError *)error
{
    if (!error) {
        [self updateTableView:error];
    }
}

- (void)postFinishedWithError:(NSError *)error
{
    if (!error) {
        NSLog(@"感谢反馈");
        [self updateTextField:error];
    }
    else {
        NSLog(@"发送失败");
        [self updateTableView:error];
    }
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendFeedback];
    return YES;
}

@end
