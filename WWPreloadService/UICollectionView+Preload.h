//
//  UICollectionView+Preload.h
//  WanWu
//
//  Created by foyoodo on 2021/11/17.
//

#import <UIKit/UIKit.h>
#import "NSObject+PreloadService.h"
#import "UIScrollView+PreloadService.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView(Preload)

- (void)preloadWithCellClass:(Class)cellClass block:(void (^)(void))block;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
