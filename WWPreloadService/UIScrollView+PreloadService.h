//
//  UIScrollView+PreloadService.h
//  WanWu
//
//  Created by foyoodo on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView(PreloadService)

- (void)reloadDataIfNeeded;

@property (nonatomic, assign) CGPoint lastContentOffset;

@property (nonatomic, assign) NSTimeInterval lastOffsetTimeCapture;

@property (nonatomic, copy) void (^preloadBlock)(void);

@property (nonatomic, assign) BOOL preloadFlag;

@end

NS_ASSUME_NONNULL_END
