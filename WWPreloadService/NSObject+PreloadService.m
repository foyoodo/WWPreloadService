//
//  NSObject+PreloadService.m
//  WanWu
//
//  Created by foyoodo on 2021/9/17.
//

#import "NSObject+PreloadService.h"
#import <objc/runtime.h>

@implementation NSObject (PreloadService)

#pragma mark - Public Methods

+ (void)swizzleClassMethodWith:(Class)aClass originalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSel);
    Method originalReplaceMethod = class_getInstanceMethod(aClass, originalSel);

    IMP swizzledImp = method_getImplementation(swizzledMethod);
    IMP originalReplaceImp = method_getImplementation(originalReplaceMethod);

    if (!originalMethod) {
        BOOL didAddMethod = class_addMethod(self, originalSel, originalReplaceImp, method_getTypeEncoding(originalReplaceMethod));
        if (didAddMethod) {
            class_addMethod(self, swizzledSel, swizzledImp, method_getTypeEncoding(swizzledMethod));
            method_exchangeImplementations(class_getInstanceMethod(self, originalSel), class_getInstanceMethod(self, swizzledSel));
        }
    } else {
        IMP originalImp = method_getImplementation(originalMethod);
        if (originalImp != swizzledImp) {
            Class selOriginClass = [self originalClassForSelector:originalSel];
            BOOL didAddMethod = class_addMethod(selOriginClass, swizzledSel, swizzledImp, method_getTypeEncoding(swizzledMethod));
            if (didAddMethod) {
                method_exchangeImplementations(class_getInstanceMethod(selOriginClass, originalSel), class_getInstanceMethod(selOriginClass, swizzledSel));
            }
        } else if (!class_getInstanceMethod(self, swizzledSel)) {
            class_addMethod(self, swizzledSel, originalReplaceImp, method_getTypeEncoding(originalReplaceMethod));
        }
    }
}

#pragma mark - Private Methods

+ (Class)originalClassForSelector:(SEL)sel {
    Class superClass = [self superclass];
    if ([superClass instancesRespondToSelector:sel] &&
        [superClass instanceMethodForSelector:sel] == [self instanceMethodForSelector:sel]) {
        return [superClass originalClassForSelector:sel];
    }
    return self;
}

#pragma mark - Getter & Setter

- (NSUInteger)currentPage {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    objc_setAssociatedObject(self, @selector(currentPage), @(currentPage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isRequesting {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRequesting:(BOOL)requesting {
    objc_setAssociatedObject(self, @selector(isRequesting), @(requesting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isEnding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnding:(BOOL)ending {
    objc_setAssociatedObject(self, @selector(isEnding), @(ending), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
