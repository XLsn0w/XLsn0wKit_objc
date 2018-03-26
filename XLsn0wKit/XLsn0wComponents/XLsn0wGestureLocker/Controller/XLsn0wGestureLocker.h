
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UnlockType) {
    ZLUnlockTypeCreatePsw,  // 创建手势密码
    ZLUnlockTypeValidatePsw // 校验手势密码
};

@interface XLsn0wGestureLocker : UIViewController

+ (void)deleteGestureLocker;   //删除手势密码
+ (NSString *)getGesturePassword;//获取手势密码

- (instancetype)initWithUnlockType:(UnlockType)unlockType;

@end

/*

 
if (indexPath.row == 0) { // 创建手势密码
    NSLog(@"点击了---创建手势密码");
    
    ZLGestureLockViewController *vc = [[ZLGestureLockViewController alloc] initWithUnlockType:ZLUnlockTypeCreatePsw];
    [self presentViewController:vc animated:YES completion:nil];
} else if (indexPath.row == 1) { // 校验手势密码
    NSLog(@"点击了---校验手势密码");
    
    if ([ZLGestureLockViewController gesturesPassword].length > 0) {
        
        ZLGestureLockViewController *vc = [[ZLGestureLockViewController alloc] initWithUnlockType:ZLUnlockTypeValidatePsw];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"还没有设置手势密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
    }
} else if (indexPath.row == 2) { // 删除手势密码
    NSLog(@"点击了---删除手势密码");
    
    [ZLGestureLockViewController deleteGesturesPassword];
}


*/
