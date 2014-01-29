//
//  BMSearchListViewController.h
//  BananaNews
//
//  Created by 龚 涛 on 14-1-28.
//  Copyright (c) 2014年 龚涛. All rights reserved.
//

#import "GTTableViewController.h"

#import "BMUserSearchView.h"

@interface BMSearchListViewController : GTTableViewController <UMSocialUIDelegate, UITextFieldDelegate, BMUserSearchViewDelegate>
{
    BOOL _isSearch;
    
    NSInteger _postId;
    
    UIActivityIndicatorView *_indicatorView;
}

@end
