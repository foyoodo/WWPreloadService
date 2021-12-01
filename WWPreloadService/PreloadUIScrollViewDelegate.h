//
//  PreloadUIScrollViewDelegate.h
//  WanWu
//
//  Created by foyoodo on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreloadUIScrollViewDelegate : NSObject

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)preload_scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)preload_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)preload_scrollViewDidScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
