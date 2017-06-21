
#import <UIKit/UIKit.h>

@interface UIImage (QRenCodeImage)

/**
 * 如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影：
 *  ImageView.layer.shadowOffset = CGSizeMake(0, 0.5);  // 设置阴影的偏移量
    ImageView.layer.shadowRadius = 1;  // 设置阴影的半径
    ImageView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
     ImageView.layer.shadowOpacity = 0.3; // 设置阴影的不透明度
 */

/**
*   1. 生成 二维码图片
*
*/

+(CIImage *)createQRForString:(NSString *)qrString;
/**
 *  2.类型转换 改变图片大小 对图像进行清晰化处理
 */

+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

/**
 *  因为生成的二维码是黑白的，所以还要对二维码进行颜色填充，并转换为透明背景，使用遍历图片像素来更改图片颜色，因为使用的是CGContext，速度非常快：
 *
 */
+(UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

/**
 *  @brief 中间插入一张图片
 *
  */
+ (UIImage *)imageInsertedImage: (UIImage *)originImage insertImage: (UIImage *)insertImage radius: (CGFloat)radius;

@end
