
#import <UIKit/UIKit.h>

@interface MaskBlurView : UIView

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
