//
//  UITableView+Preload.h
//  WanWu
//
//  Created by foyoodo on 2021/9/17.
//

#import <UIKit/UIKit.h>
#import "NSObject+PreloadService.h"
#import "UIScrollView+PreloadService.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Preload)

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
