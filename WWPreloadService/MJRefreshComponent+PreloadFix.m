//
//  MJRefreshComponent+PreloadFix.m
//  WanWu
//
//  Created by foyoodo on 2021/11/24.
//

#import "MJRefreshComponent+PreloadFix.h"
#import "UIScrollView+PreloadService.h"
#import <objc/runtime.h>

@implementation MJRefreshComponent(PreloadFix)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSel = @selector(setState:);
        SEL swizzledSel = @selector(preloadfix_setState:);

        Method originalMethod = class_getInstanceMethod(self, originalSel);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSel);

        NSAssert(originalMethod, @"Please check `setState:` method if exist of MJRefreshComponent");

        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)preloadfix_setState:(MJRefreshState)state {
    [self preloadfix_setState:state];
    if (state == MJRefreshStateIdle) {
        UIScrollView *scrollView = self.scrollView;
        if (scrollView && scrollView.preloadFlag) {
            CGRect scrollViewRect = scrollView.frame;
            CGRect rect = [[scrollView superview] convertRect:self.frame fromView:scrollView];
            if (rect.origin.y < scrollViewRect.origin.y + scrollViewRect.size.height) {
                [scrollView reloadDataIfNeeded];
            }
        }
    }
}

@end
