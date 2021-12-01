//
//  UICollectionView+Preload.m
//  WanWu
//
//  Created by foyoodo on 2021/11/17.
//

#import "UICollectionView+Preload.h"
#import "PreloadUIScrollViewDelegate.h"
#import <objc/runtime.h>

static const NSUInteger kPreloadMinCount = 8;

@interface UICollectionView ()

@property (nonatomic, strong) NSIndexPath *preloadIndexPath;

@property (nonatomic, strong) Class preloadCellClass;

@end

@implementation UICollectionView(Preload)

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

- (Class)preloadCellClass {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPreloadCellClass:(Class)preloadCellClass {
    objc_setAssociatedObject(self, @selector(preloadCellClass), preloadCellClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)preloadIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPreloadIndexPath:(NSIndexPath *)preloadIndexPath {
    objc_setAssociatedObject(self, @selector(preloadIndexPath), preloadIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)dataArray {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    objc_setAssociatedObject(self, @selector(dataArray), dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)preloadDataWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != self.preloadIndexPath.section) {
        return;
    }
    NSUInteger totalCount = self.dataArray.count;
    if (indexPath.item + kPreloadMinCount == totalCount + self.preloadIndexPath.item) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.preloadBlock();
        });
    }
}

- (void)preload_setDelegate:(id<UITableViewDelegate>)delegate {
    SEL originalSelector = @selector(collectionView:willDisplayCell:forItemAtIndexPath:);
    SEL swizzledSelector = @selector(preload_collectionView:willDisplayCell:forItemAtIndexPath:);

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

- (void)preload_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!collectionView.preloadIndexPath && [cell isKindOfClass:collectionView.preloadCellClass]) {
        collectionView.preloadIndexPath = indexPath;
    }
    if (collectionView.preloadIndexPath && collectionView.preloadBlock) {
        if (!collectionView.isRequesting && !collectionView.isEnding) {
            [collectionView preloadDataWithIndexPath:indexPath];
        }
    }
    [self preload_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}

#pragma mark - Public Methods

- (void)preloadWithCellClass:(Class)cellClass block:(void (^)(void))block {
    self.preloadCellClass = cellClass;
    self.preloadBlock = block;
}

@end
