
#import <UIKit/UIKit.h>

@interface XLChannelView : UIView

@property (nonatomic, strong) NSMutableArray *inUseTitles;

@property (nonatomic,strong) NSMutableArray *unUseTitles;

-(void)reloadData;

@end
