
#import <UIKit/UIKit.h>

typedef void(^UIAlertViewJKCallBackBlock)(NSInteger buttonIndex);

@interface UIAlertView (JKBlock)<UIAlertViewDelegate>

@property (nonatomic, copy) UIAlertViewJKCallBackBlock jk_alertViewCallBackBlock;

+ (void)jk_alertWithCallBackBlock:(UIAlertViewJKCallBackBlock)alertViewCallBackBlock
                            title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName
                otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@end
