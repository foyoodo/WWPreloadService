//
//  UIScrollView+PreloadService.m
//  WanWu
//
//  Created by foyoodo on 2021/11/19.
//

#import "UIScrollView+PreloadService.h"
#import <objc/runtime.h>

@implementation UIScrollView(PreloadService)

#pragma mark - Public Methods

- (void)reloadData {
    // empty implemention
}

- (void)reloadDataIfNeeded {
    if (self.preloadFlag) {
        [self reloadData];
        self.preloadFlag = NO;
    }
}

#pragma mark - Getter & Setter

- (CGPoint)lastContentOffset {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setLastContentOffset:(CGPoint)lastContentOffset {
    objc_setAssociatedObject(self, @selector(lastContentOffset), @(lastContentOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)lastOffsetTimeCapture {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setLastOffsetTimeCapture:(NSTimeInterval)lastOffsetTimeCapture {
    objc_setAssociatedObject(self, @selector(lastOffsetTimeCapture), @(lastOffsetTimeCapture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))preloadBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPreloadBlock:(void (^)(void))preloadBlock {
    objc_setAssociatedObject(self, @selector(preloadBlock), preloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)preloadFlag {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setPreloadFlag:(BOOL)preloadFlag {
    objc_getAssociatedObject(self, @selector(preloadFlag)) ?: [self reloadData];
    objc_setAssociatedObject(self, @selector(preloadFlag), @(preloadFlag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
