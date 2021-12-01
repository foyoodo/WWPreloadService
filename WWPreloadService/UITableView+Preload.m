//
//  UITableView+Preload.m
//  WanWu
//
//  Created by foyoodo on 2021/9/17.
//

#import "UITableView+Preload.h"
#import "PreloadUIScrollViewDelegate.h"
#import <objc/runtime.h>

static const NSUInteger kPreloadMinCount = 5;

@implementation UITableView (Preload)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(setDelegate:);
        SEL swizzledSelector = @selector(preload_setDelegate:);

        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);

        BOOL didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)preloadDataWithCurrentIndex:(NSUInteger)index {
    NSUInteger totalCount = self.dataArray.count;
    if (index + kPreloadMinCount == totalCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.preloadBlock();
        });
    }
}

#pragma mark - Hook

- (void)preload_setDelegate:(id<UITableViewDelegate>)delegate {
    SEL originalSelector = @selector(tableView:cellForRowAtIndexPath:);
    SEL swizzledSelector = @selector(preload_tableView:cellForRowAtIndexPath:);

    if ([delegate respondsToSelector:originalSelector]) {
        Class clz = [delegate class];

        Method originalMethod = class_getInstanceMethod(clz, originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);

        IMP originalImp = method_getImplementation(originalMethod);
        IMP swizzledImp = method_getImplementation(swizzledMethod);

        if (originalImp != swizzledImp) {
            BOOL didAddMethod = class_addMethod(clz, swizzledSelector, originalImp, method_getTypeEncoding(originalMethod));
            if (didAddMethod) {
                class_replaceMethod(clz, originalSelector, swizzledImp, method_getTypeEncoding(swizzledMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }

    PreloadUIScrollViewDelegate *pdelegate = [PreloadUIScrollViewDelegate new];

    [[delegate class] swizzleClassMethodWith:[pdelegate class]
                                 originalSel:@selector(scrollViewWillBeginDragging:)
                                 swizzledSel:@selector(preload_scrollViewWillBeginDragging:)];
    [[delegate class] swizzleClassMethodWith:[pdelegate class]
                                 originalSel:@selector(scrollViewDidEndDecelerating:)
                                 swizzledSel:@selector(preload_scrollViewDidEndDecelerating:)];
    [[delegate class] swizzleClassMethodWith:[pdelegate class]
                                 originalSel:@selector(scrollViewDidScroll:)
                                 swizzledSel:@selector(preload_scrollViewDidScroll:)];

    [self preload_setDelegate:delegate];
}

- (UITableViewCell *)preload_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.preloadBlock) {
        if (!tableView.isRequesting && !tableView.isEnding) {
            [tableView preloadDataWithCurrentIndex:indexPath.row];
        }
    }
    return [self preload_tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Getter & Setter

- (NSMutableArray *)dataArray {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    objc_setAssociatedObject(self, @selector(dataArray), dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
