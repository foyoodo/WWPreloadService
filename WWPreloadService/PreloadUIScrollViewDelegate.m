//
//  PreloadUIScrollViewDelegate.m
//  WanWu
//
//  Created by foyoodo on 2021/11/19.
//

#import "PreloadUIScrollViewDelegate.h"
#import "UIScrollView+PreloadService.h"

@implementation PreloadUIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)preload_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !scrollView.preloadBlock ?: [scrollView reloadDataIfNeeded];
    [self preload_scrollViewWillBeginDragging:scrollView];
}

- (void)preload_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    !scrollView.preloadBlock ?: [scrollView reloadDataIfNeeded];
    [self preload_scrollViewDidEndDecelerating:scrollView];
}

- (void)preload_scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.preloadBlock) {
        CGPoint currentOffset = scrollView.contentOffset;
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];

        NSTimeInterval timeDiff = currentTime - scrollView.lastOffsetTimeCapture;
        if (timeDiff > 0.1) {
            CGFloat distance = currentOffset.y - scrollView.lastContentOffset.y;
            CGFloat scrollSpeedNotAbs = (distance * 10) / 1000;

            CGFloat scrollSpeed = fabs(scrollSpeedNotAbs);
            if (scrollSpeed < 0.4) {
                [scrollView reloadDataIfNeeded];
            }

            scrollView.lastContentOffset = currentOffset;
            scrollView.lastOffsetTimeCapture = currentTime;
        }
    }
    [self preload_scrollViewDidScroll:scrollView];
}

@end
