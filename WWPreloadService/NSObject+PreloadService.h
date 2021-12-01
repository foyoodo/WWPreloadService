//
//  NSObject+PreloadService.h
//  WanWu
//
//  Created by foyoodo on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (PreloadService)

+ (void)swizzleClassMethodWith:(Class)aClass originalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel;

@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, assign, getter=isRequesting) BOOL requesting;

@property (nonatomic, assign, getter=isEnding) BOOL ending;

@end

NS_ASSUME_NONNULL_END
