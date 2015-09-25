//
//  ViewController.m
//  WUParallaxView
//
//  Created by wuqh on 15/9/25.
//  Copyright © 2015年 SL. All rights reserved.
//

#import "ViewController.h"

#define kHeadH 260.0f //头视图的高度
#define kHeadMinH 64.0f //状态栏高度20 + 导航栏高度44
#define kBarH 29.0f//头视图下边选项卡的高度

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.alpha = 0;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.contentInset = UIEdgeInsetsMake(kHeadH + kBarH, 0, 0, 0);
    
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.visualEffectView.alpha = 0;
    self.visualEffectView.frame = self.headView.bounds;
    [self.headView addSubview:self.visualEffectView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //计算偏移量，默认是-289；
    CGFloat beginOffsetY = -(kHeadH + kBarH);
    CGFloat offsetY = scrollView.contentOffset.y - beginOffsetY;
    
    //向下拉: offsetY为负值，并且越来越小 这时图片高度需要变大
    //向上拉: offsetY为正值，并且越来越大，这是图片高度需要变小
    
    //所以
    CGFloat height = kHeadH - offsetY;
    //当向上拖动的时候，头视图会越来越小，为了让选项卡，能够停留在导航栏下方。需要设置图片的最小高度是64。
    if (height < kHeadMinH) {
        height = kHeadMinH;
    }
    
    self.headViewHeight.constant = height;
    
    
    // 设置导航条的透明度
    CGFloat alpha = offsetY / (kHeadH - kHeadMinH);
    if (alpha >=1) {
        alpha = 1;
    }
    NSLog(@"%f",alpha);
    self.navigationController.navigationBar.alpha = alpha;
    self.visualEffectView.alpha = alpha;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

#pragma mark - UITableViewDataSource 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}







@end
