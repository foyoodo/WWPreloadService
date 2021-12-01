//
//  TableViewController.m
//  WWPreloadServiceDemo
//
//  Created by foyoodo on 2021/11/30.
//

#import "TableViewController.h"
#import "MJRefresh.h"
#import "UITableView+Preload.h"

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = 150;
    self.tableView.estimatedRowHeight = 150;

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"id"];

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.data removeAllObjects];
        [self loadMoreData];
    }];
    header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = header;

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    }];

    [self.tableView.mj_header beginRefreshing];

    // Preload Service
    __weak typeof(self) weakSelf = self;
    self.tableView.preloadBlock = ^{
        [weakSelf loadMoreData];
    };
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.data.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.data removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Private Methods

- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 10; ++i) {
            [self.data addObject:@(0)];
        }
        self.tableView.preloadFlag = YES;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
}

#pragma mark - Override

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
        self.tableView.dataArray = _data;
    }
    return _data;
}

@end
