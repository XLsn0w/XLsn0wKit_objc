/***********************************************************************************************
 *     __      __   _         _________     _ _     _    _________   __         _         __   *
 *     \ \    / /  | |        | _______|   | | \   | |  |  ______ |  \ \       / \       / /   *
 *      \ \  / /   | |        | |          | |\ \  | |  | |     | |   \ \     / \ \     / /    *
 *       \ \/ /    | |        | |______    | | \ \ | |  | |     | |    \ \   / / \ \   / /     *
 *       /\/\/\    | |        |_______ |   | |  \ \| |  | |     | |     \ \ / /   \ \ / /      *
 *      / /  \ \   | |______   ______| |   | |   \ \ |  | |_____| |      \ \ /     \ \ /       *
 *     /_/    \_\  |________| |________|   |_|    \__|  |_________|       \_/       \_/        *
 *                                                                                             *
 ***********************************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NSUInteger QRCodeImagerInputCorrectionLevel;

//L，M，Q，H ---> low ， Med， M.high ， High
NS_ENUM(QRCodeImagerInputCorrectionLevel) {
    High = 1,
    Low  = 2
};
    
@interface XLsn0wQRCodeLogo : UIImage


/**
 生成默认黑色二维码
 */
+ (UIImage *_Nullable)imageWithQRMessage:(NSString *_Nonnull)message headImage:(UIImage *_Nullable)headImage inputCorrectionLevel:(QRCodeImagerInputCorrectionLevel)correctionLevel sideLength:(CGFloat)sideLength;

/**
 *  1.生成一个二维码
 *
 *  @param string 字符串
 *  @param width  二维码宽度
 */
+ (XLsn0wQRCodeLogo *_Nonnull)codeImageWithString:(NSString *_Nullable)string
                                                  size:(CGFloat)width;

/**
 *  2.生成一个二维码
 *
 *  @param string 字符串
 *  @param width  二维码宽度
 *  @param color  二维码颜色
 */
+ (XLsn0wQRCodeLogo *_Nonnull)codeImageWithString:(NSString *_Nullable)string
                                        size:(CGFloat)width
                                       color:(UIColor *_Nullable)color;
/**
 *  3.生成一个二维码
 *
 *  @param string    字符串
 *  @param width     二维码宽度
 *  @param color     二维码颜色
 *  @param icon      头像
 *  @param iconWidth 头像宽度，建议宽度小于二维码宽度的1/4
 *
 */
+ (XLsn0wQRCodeLogo *_Nonnull)codeImageWithString:(NSString *_Nullable)string
                                        size:(CGFloat)width
                                       color:(UIColor *_Nullable)color
                                        icon:(UIImage *_Nullable)icon
                                   iconWidth:(CGFloat)iconWidth;

@end
