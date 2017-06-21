
#import <UIKit/UIKit.h>

@interface UIApplication (CurrentShowedVC)

+ (UIViewController *)getCurrentShowedViewContrller;

/*
 一个UIView对象当前正在显示，那么它的window属性肯定为非空值。
 访问UIViewController的view属性时，
 可能会引起view加载(假如此时还未加载)，这是不必要的，而且还可能引起无法预期的问题。因此在访问view属性之前，最好先检查isViewLoaded属性来避免上述问题。
 
 */
+ (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;

@end
