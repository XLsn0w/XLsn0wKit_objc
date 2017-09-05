

#import <UIKit/UIKit.h>

@interface XLCircle : UIView

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth;

@property (assign,nonatomic) float progress;

@property (assign,nonatomic) CGFloat lineWidth;

@end

/**
 XLCircleProgress *_circle;
 
 -(void)addCircle
 {
 CGFloat margin = 15.0f;
 CGFloat circleWidth = [UIScreen mainScreen].bounds.size.width - 2*margin;
 _circle = [[XLCircleProgress alloc] initWithFrame:CGRectMake(0, 0, circleWidth, circleWidth)];
 _circle.center = self.view.center;
 [self.view addSubview:_circle];
 
 UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_circle.frame) + 50, self.view.bounds.size.width - 2*50, 30)];
 [slider addTarget:self action:@selector(sliderMethod:) forControlEvents:UIControlEventValueChanged];
 [slider setMaximumValue:1];
 [slider setMinimumValue:0];
 [slider setMinimumTrackTintColor:[UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:0/255.0f alpha:1]];
 [self.view addSubview:slider];
 }
 
 -(void)sliderMethod:(UISlider*)slider
 {
 _circle.progress = slider.value;
 }
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 }
 */
