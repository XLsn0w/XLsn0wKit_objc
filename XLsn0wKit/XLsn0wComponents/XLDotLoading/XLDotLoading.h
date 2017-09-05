
#import <UIKit/UIKit.h>

@interface XLDotLoading : UIView

//显示方法
+(void)showInView:(UIView*)view;
//隐藏方法
+(void)hideInView:(UIView*)view;

-(void)start;

-(void)stop;

@end

/**
 
 [XLDotLoading showInView:self.view];
 
 */
