

#import <UIKit/UIKit.h>

@interface XLChannelItem : UICollectionViewCell
//标题
@property (nonatomic, copy) NSString *title;

//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;

//是否被固定
@property (nonatomic, assign) BOOL isFixed;

@end
