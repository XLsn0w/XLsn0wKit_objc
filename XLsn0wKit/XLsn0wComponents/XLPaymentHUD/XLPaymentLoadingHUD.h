
#import <UIKit/UIKit.h>


@interface XLPaymentLoadingHUD : UIView

-(void)start;

-(void)hide;

+(XLPaymentLoadingHUD*)showIn:(UIView*)view;

+(XLPaymentLoadingHUD*)hideIn:(UIView*)view;

@end


/**
 
 //隐藏支付完成动画
 [XLPaymentSuccessHUD hideIn:self.view];
 //显示支付中动画
 [XLPaymentLoadingHUD showIn:self.view];

 //隐藏支付中成动画
 [XLPaymentLoadingHUD hideIn:self.view];
 //显示支付完成动画
 [XLPaymentSuccessHUD showIn:self.view];
 
 */
