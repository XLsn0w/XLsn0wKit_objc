
#import <UIKit/UIKit.h>

@interface XLBallLoading : UIView

-(void)start;
-(void)stop;

+(void)showInView:(UIView*)view;

+(void)hideInView:(UIView*)view;

@end

/**
 
 //显示BallLoading
 [XLBallLoading showInView:self.view];
 
 //隐藏BallLoading
 [XLBallLoading hideInView:self.view];
 
 */
