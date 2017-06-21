/*********************************************************************************************
 *   __      __   _         _________     _ _     _    _________   __         _         __   *
 *	 \ \    / /  | |        | _______|   | | \   | |  |  ______ |  \ \       / \       / /   *
 *	  \ \  / /   | |        | |          | |\ \  | |  | |     | |   \ \     / \ \     / /    *
 *     \ \/ /    | |        | |______    | | \ \ | |  | |     | |    \ \   / / \ \   / /     *
 *     /\/\/\    | |        |_______ |   | |  \ \| |  | |     | |     \ \ / /   \ \ / /      *
 *    / /  \ \   | |______   ______| |   | |   \ \ |  | |_____| |      \ \ /     \ \ /       *
 *   /_/    \_\  |________| |________|   |_|    \__|  |_________|       \_/       \_/        *
 *                                                                                           *
 *********************************************************************************************/

#import "XLsn0wHUD.h"

#import "XLsn0wTextHUD.h"
#import "XLsn0wLoadHUD.h"

static NSMutableArray *HUDArray;

@interface XLsn0wHUD () <XLsn0wHUDDelegate>

@end

@implementation XLsn0wHUD

+ (void)load {
    HUDArray = [NSMutableArray array];
}

+ (instancetype)showLoadText:(NSString *)loadText superview:(UIView *)superview animated:(BOOL)animated {
    XLsn0wHUD *HUD = [[XLsn0wLoadHUD alloc] initWithFrame:superview.bounds];
    HUD.selfView = superview;
    HUD.text = loadText;
    
    [HUD addIndicator];
    [HUD addText];
    [HUD compositeElements];
    
    [HUD show:animated withDuration:0 completion:nil];
    
    return HUD;
}

+ (instancetype)showTipText:(NSString *)tipText superview:(UIView *)superview duration:(NSTimeInterval)duration animated:(BOOL)animated {
    XLsn0wHUD *HUD = [[XLsn0wTextHUD alloc] initWithFrame:superview.bounds];
    HUD.selfView = superview;
    HUD.text = tipText;
    
    [HUD addText];
    [HUD compositeElements];
    
    [HUD show:animated withDuration:duration completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD dismiss:animated];
        });
    }];
    
    return HUD;
}

+ (void)dismissSuperview:(UIView *)superview animated:(BOOL)animated {
    for (XLsn0wHUD *HUD in HUDArray) {
        if ([HUD.selfView isEqual:superview]) {
            [HUD dismiss:animated];
        }
    }
}

+ (void)dismissAll:(BOOL)animated {
    for (XLsn0wHUD *HUD in HUDArray) {
        [HUD dismiss:animated];
    }
}

- (void)dismiss:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *view in self.subviews) {
                view.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [HUDArray removeObject:self];
        }];
    }
    else {
        [self removeFromSuperview];
        [HUDArray removeObject:self];
    }
}

- (void)show:(BOOL)animated withDuration:(NSTimeInterval)duration completion:(void (^)())completion {
    [self addSubview:self.backView];
    [HUDArray addObject:self];
    
    if (animated) {
        self.alpha = 0;
        [self.selfView addSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion != NULL) {
                completion();
            }
        }];
    }
    else {
        [self.selfView addSubview:self];
    }
}

@end


