//
//  ViewController.m
//  WWPreloadServiceDemo
//
//  Created by foyoodo on 2021/11/29.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBlueColor];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    button.backgroundColor = [UIColor systemRedColor];
    [button setTitle:@"TableView" forState:UIControlStateNormal];
    button.tag = 1000;
    button.center = self.view.center;

    [self.view addSubview:button];

    [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonDidClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1000: {
            TableViewController *tableViewController = [[TableViewController alloc] init];
            tableViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:tableViewController animated:NO completion:nil];
        } break;

        default:
            break;
    }
}

@end
