
#import <UIKit/UIKit.h>

@interface XLPaymentSuccessHUD : UIView<CAAnimationDelegate>

-(void)start;

-(void)hide;

+(XLPaymentSuccessHUD*)showIn:(UIView*)view;

+(XLPaymentSuccessHUD*)hideIn:(UIView*)view;

@end
