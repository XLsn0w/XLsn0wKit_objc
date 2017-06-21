//
//  MLMaskBlurView.h
//  TestCode
//
//  Created by 蔡杰 on 2017/5/24.
//  Copyright © 2017年 蔡杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JEasyMaskBlurView : UIView

/**
 视图显示
 */

- (void)showInKeyWindow;

- (void)showInView:(UIView *_Nonnull )superView NS_REQUIRES_SUPER;

/*
     子类覆盖
 */
- (void)setupSubViews;

//视图消失
- (void)dismiss;

@end
