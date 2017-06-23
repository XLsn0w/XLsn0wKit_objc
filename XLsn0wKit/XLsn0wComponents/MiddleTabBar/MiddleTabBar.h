
#import <UIKit/UIKit.h>

@protocol MiddleTabBarDelegate <NSObject>

- (void)hookMiddleButtonEventWithMiddleButton:(UIButton *)middleButton;

@end

@class  MiddleButton;

@interface MiddleTabBar : UITabBar

@property (nonatomic, weak) id <MiddleTabBarDelegate> xlsn0w_delegate;

@property (nonatomic, strong) MiddleButton *middleButton;

@end

@interface MiddleButton : UIButton

@end
