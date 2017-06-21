

#import <UIKit/UIKit.h>

@interface UIImage (JRoundRectImage)

+ (UIImage *)imageOfRoundRectWithImage: (UIImage *)image
                                  size: (CGSize)size
                                radius: (CGFloat)radius;
@end
