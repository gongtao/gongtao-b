//
//  BMSubmissionViewController.m
//  BananaNews
//
//  Created by 龚涛 on 12/30/13.
//  Copyright (c) 2013 龚涛. All rights reserved.
//

#import "BMSubmissionViewController.h"

#import "BMSNSLoginButton.h"

#import "BMUtils.h"

#import <MMProgressHUD.h>

@interface BMSubmissionViewController ()
{
    UIScrollView *_scrollView;
    
    UIView *_contentView;
    UIView *_newsContentView;
    UIView *_imageContentView;
    UIView *_imageFrameView;
    UIView *_imageSourceView;
    
    UIButton *_imageButton;
}

@property (nonatomic, assign) NSUInteger number;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSMutableArray *imageArray;

- (void)_initContentView;

- (void)_updateContentView;

- (void)_submit:(UIButton *)button;

- (void)_addImage:(UIButton *)button;

- (void)_selectImageStyle:(UIButton *)button;

- (UIImage *)_imageHandle:(UIImage *)image;

- (void)_dissmissImageSourceView:(UITapGestureRecognizer *)gesture;

- (void)_clearContent;

@end

@implementation BMSubmissionViewController

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
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 44., 44.)];
    [button setImage:[UIImage imageNamed:@"反馈投递.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"反馈投递.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(_submit:) forControlEvents:UIControlEventTouchUpInside];
    self.customNavigationBar.rightView = button;
    
    CGFloat y = CGRectGetMaxY(self.customNavigationBar.frame);
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, y, self.view.frame.size.width, self.view.frame.size.height-y)];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-y+5.0);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    [self _initContentView];
    
    self.number = 0;
    
    self.imageArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_initContentView
{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(6.0, 5.0, 308.0, 250.0)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.borderWidth = 1.0;
    _contentView.layer.borderColor = Color_GrayLine.CGColor;
    _contentView.layer.cornerRadius = 2.0;
    [_scrollView addSubview:_contentView];
    
    _newsContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 308.0, 160.0)];
    _newsContentView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_newsContentView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0, 0.0, 100.0, 22.0)];
    contentLabel.text = @"添加文字";
    contentLabel.font = Font_NewsSmall;
    contentLabel.textColor = Color_NewsSmallFont;
    [_newsContentView addSubview:contentLabel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(6.0, 22.0, 296.0, 128.0)];
    _textView.textColor = Color_NewsFont;
    _textView.font = Font_NewsTitle;
    _textView.backgroundColor = Color_UploadFrameBg;
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = Color_GrayLine.CGColor;
    [_newsContentView addSubview:_textView];
    
    _imageContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 160.0, 308.0, 90.0)];
    _imageContentView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_imageContentView];
    
    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0, 0.0, 100.0, 22.0)];
    imageLabel.text = @"添加图片";
    imageLabel.font = Font_NewsSmall;
    imageLabel.textColor = Color_NewsSmallFont;
    [_imageContentView addSubview:imageLabel];
    
    _imageFrameView = [[UIView alloc] initWithFrame:CGRectMake(6.0, 22.0, 296.0, 58.0)];
    _imageFrameView.backgroundColor = Color_UploadFrameBg;
    _imageFrameView.layer.borderWidth = 1.0;
    _imageFrameView.layer.borderColor = Color_GrayLine.CGColor;
    _imageFrameView.layer.cornerRadius = 2.0;
    [_imageContentView addSubview:_imageFrameView];
    
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0, 7.0, 67.0, 44.0)];
    _imageButton.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [_imageButton setImage:[UIImage imageNamed:@"投稿图片添加.png"] forState:UIControlStateNormal];
    [_imageButton setImage:[UIImage imageNamed:@"投稿图片添加.png"] forState:UIControlStateHighlighted];
    [_imageButton addTarget:self action:@selector(_addImage:) forControlEvents:UIControlEventTouchUpInside];
    [_imageFrameView addSubview:_imageButton];
}

- (void)_updateContentView
{
    CGRect frame = _contentView.frame;
    frame.size.height = _newsContentView.frame.size.height + _imageContentView.frame.size.height;
    _contentView.frame = frame;
    
    CGFloat h1 = self.view.bounds.size.height-CGRectGetMaxY(self.customNavigationBar.frame)+5.0;
    CGFloat h2 = frame.size.height+10.0;
    if (h1 > h2) {
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, h1);
    }
    else {
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, h2);
    }
}

- (void)_submit:(UIButton *)button
{
    [self.view endEditing:YES];
    if (!self.textView.text || self.textView.text.length>0) {
        [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
        [MMProgressHUD showWithTitle:@"" status:@"投稿发送中。。。"];
        [[BMNewsManager sharedManager] getSubmission:self.textView.text
                                            imageNum:_imageArray
                                             success:^(void){
                                                 [MMProgressHUD dismissWithSuccess:@"投稿成功"];
                                                 [self _clearContent];
                                             }
                                             failure:^(NSError *error){
                                                 [MMProgressHUD dismissWithError:@"投稿失败"];
                                                 [self _clearContent];
                                             }];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"投稿" message:@"亲~请先输入内容" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)_addImage:(UIButton *)button
{
    [self.view endEditing:YES];
    if (!_imageSourceView) {
        _imageSourceView = [[UIView alloc] initWithFrame:self.view.bounds];
        _imageSourceView.layer.backgroundColor = [UIColor colorWithHexString:@"99000000"].CGColor;
        _imageSourceView.userInteractionEnabled = YES;
        _imageSourceView.alpha = 0.0;
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor clearColor];
        [_imageSourceView addSubview:view];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dissmissImageSourceView:)];
        [view addGestureRecognizer:gesture];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 183.0, 111.0)];
        contentView.center = CGPointMake(CGRectGetMidX(_imageSourceView.frame), CGRectGetMidY(_imageSourceView.frame)-20.0);
        contentView.backgroundColor = Color_GrayLine;
        [_imageSourceView addSubview:contentView];
        
        BMSNSLoginButton *button1 = [[BMSNSLoginButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 183.0, 55.0)];
        button1.titleLabel.text = @"拍照";
        [button1 addTarget:self action:@selector(_selectImageStyle:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 0;
        [contentView addSubview:button1];
        
        BMSNSLoginButton *button2 = [[BMSNSLoginButton alloc] initWithFrame:CGRectMake(0.0, 56.0, 183.0, 55.0)];
        button2.titleLabel.text = @"手机相册";
        [button2 addTarget:self action:@selector(_selectImageStyle:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 1;
        [contentView addSubview:button2];
        
        [self.parentViewController.view addSubview:_imageSourceView];
    }
    [UIView animateWithDuration:0.3 animations:^(void){
        _imageSourceView.alpha = 1.0;
    }];
}

- (void)_selectImageStyle:(UIButton *)button
{
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         _imageSourceView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
                         if (0 == button.tag) {
                             type = UIImagePickerControllerSourceTypeCamera;
                         }
                         if ([UIImagePickerController isSourceTypeAvailable:type]) {
                             UIImagePickerController *vc = [[UIImagePickerController alloc] init];
                             vc.delegate = self;
                             vc.sourceType = type;
                             [self presentViewController:vc animated:YES completion:nil];
                         }
                     }];
}

- (UIImage *)_imageHandle:(UIImage *)image
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSURL *url = [[BMUtils applicationTempDirectory] URLByAppendingPathComponent:[[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".jpg"]];
    NSLog(@"image:%@", url);
    NSError *error;
    [UIImageJPEGRepresentation(image, 1.0) writeToURL:url options:NSDataWritingAtomic error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return nil;
    }
    else {
        [_imageArray addObject:url];
        self.number++;
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat h = image.size.height*_imageButton.frame.size.width/image.size.width;
    return [BMUtils scaleImage:image size:CGSizeMake(_imageButton.frame.size.width*scale, h*scale)];
}

- (void)_dissmissImageSourceView:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         _imageSourceView.alpha = 0.0;
                     }];
}

- (void)_clearContent
{
    [_imageButton removeFromSuperview];
    _imageButton.frame = CGRectMake(5.0, 7.0, 67.0, 44.0);
    
    _imageContentView.frame = CGRectMake(0.0, 160.0, 308.0, 90.0);
    
    [_imageFrameView removeFromSuperview];
    _imageFrameView = nil;
    
    _imageFrameView = [[UIView alloc] initWithFrame:CGRectMake(6.0, 22.0, 296.0, 58.0)];
    _imageFrameView.backgroundColor = Color_UploadFrameBg;
    _imageFrameView.layer.borderWidth = 1.0;
    _imageFrameView.layer.borderColor = Color_GrayLine.CGColor;
    _imageFrameView.layer.cornerRadius = 2.0;
    [_imageContentView addSubview:_imageFrameView];
    
    [_imageFrameView addSubview:_imageButton];
    
    self.textView.text = @"";
    
    [self.imageArray removeAllObjects];
    self.number = 0;
    
    [self _updateContentView];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [MMProgressHUD setDisplayStyle:MMProgressHUDDisplayStylePlain];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"" status:@"图片处理中。。。"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        UIImage *newImage = [self _imageHandle:image];
        if (!newImage) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [MMProgressHUD dismissWithError:@"图片获取失败"];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [MMProgressHUD dismissWithSuccess:@"图片处理完成"];
            
            [self dismissViewControllerAnimated:YES completion:^(void){
                CGRect frame = _imageButton.frame;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                imageView.image = newImage;
                [_imageFrameView addSubview:imageView];
                
                if (self.number % 4 == 0) {
                    CGRect frame1 = _imageFrameView.frame;
                    CGFloat h = _imageButton.frame.size.height+6.0;
                    frame1.size.height += h;
                    _imageFrameView.frame = frame1;
                    
                    frame1 = _imageContentView.frame;
                    frame1.size.height += h;
                    _imageContentView.frame = frame1;
                    
                    frame.origin.x = 5.0;
                    frame.origin.y += h;
                }
                else {
                    frame.origin.x += _imageButton.frame.size.width+6.0;
                }
                _imageButton.frame = frame;
                [self _updateContentView];
            }];
        });
    });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
