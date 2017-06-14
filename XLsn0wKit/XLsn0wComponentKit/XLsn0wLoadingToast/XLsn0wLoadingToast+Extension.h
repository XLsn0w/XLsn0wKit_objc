
#import "XLsn0wLoadingToast.h"

@class XLsn0wLoadingToast;

@interface XLsn0wLoadingToast (Extension)

//显示框显示在指定View上
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (XLsn0wLoadingToast *)showMessage:(NSString *)message toView:(UIView *)view;


//默认显示框显示在窗口顶层View上
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (XLsn0wLoadingToast *)showMessage:(NSString *)message;

//隐藏显示框
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end




