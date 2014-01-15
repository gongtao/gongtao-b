//
//  JKPlaceHolderTextView.h
//  FoodSecurity
//
//  Created by da chang on 12-7-23.
//  Copyright (c) 2012年 jike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMPlaceHolderTextView : UITextView

@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
