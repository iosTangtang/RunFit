//
//  RUNShareViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/12.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNShareViewController.h"

@interface RUNShareViewController ()

@property (nonatomic, strong) UIImageView               *screenImage;

@end

@implementation RUNShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBar.hidden = YES;
    
    [self p_setHeadView];
    [self p_setImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI Method
- (void)p_setHeadView {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setImage:[UIImage imageNamed:@"back-map"] forState:UIControlStateNormal];
    [closeButton setTintColor:[UIColor whiteColor]];
    [closeButton addTarget:self action:@selector(p_closeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(23);
        make.left.equalTo(self.view.left).offset(10);
        make.width.equalTo(22);
        make.height.equalTo(22);
    }];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cameraButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [cameraButton setTintColor:[UIColor whiteColor]];
    [cameraButton addTarget:self action:@selector(p_shareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(23);
        make.right.equalTo(self.view.right).offset(-15);
        make.width.equalTo(18);
        make.height.equalTo(22);
    }];
}

- (void)p_setImageView {
    self.screenImage = [[UIImageView alloc] init];
    self.screenImage.image = self.imageData;
    self.screenImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.screenImage];
    
    [self.screenImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY);
        make.width.equalTo(ViewWidth / 10 * 9);
        make.height.equalTo(ViewHeight / 4 * 3);
    }];
};

//- (void)p_setTool {
//    RUNTabBarViewController *tabVC = [[RUNTabBarViewController alloc] init];
//    tabVC.isRoot = NO;
//    [self addChildViewController:tabVC];
    
//    RUNPasterViewController *pasterVC = [[RUNPasterViewController alloc] init];
//    [self.tabVC addChildController:pasterVC normalImage:[UIImage imageNamed:@"paster"]
//                     selectedImage:[UIImage imageNamed:@"paster-fill"] title:@"贴纸"];
    
//    self.filterVC = [[RUNFilterViewController alloc] init];
//    self.filterVC.imageData = self.imageData;
//    self.filterVC.delegate = self;
//    [tabVC addChildController:self.filterVC normalImage:[UIImage imageNamed:@"filter"]
//                selectedImage:[UIImage imageNamed:@"filter-fill"] title:@"滤镜"];
//    
//    RUNToolViewController *toolVC = [[RUNToolViewController alloc] init];
//    toolVC.delegate = self;
//    [tabVC addChildController:toolVC normalImage:[UIImage imageNamed:@"tool"]
//                selectedImage:[UIImage imageNamed:@"tool-fill"] title:@"工具"];
//    
//    [self.view addSubview:tabVC.view];
//    
//    [tabVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.equalTo(ViewHeight / 4.0);
//    }];
//}

#pragma - Button Action
- (void)p_closeButton:(UIButton *)button {
    if (self.isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)p_shareButton:(UIButton *)button {
    NSLog(@"share");
}

//#pragma mark - RUNTool Delegate
//- (void)rotateAction:(UIButton *)button {
//    _count++;
//    CGAffineTransform transform;
//    CGFloat scaleMin = 0.85;
//    CGFloat scaleMax = 1 / 0.85;
//    if (_count % 2 == 0) {
//        transform = CGAffineTransformScale(self.screenImage.transform, scaleMax, scaleMax);
//    } else {
//        transform = CGAffineTransformScale(self.screenImage.transform, scaleMin, scaleMin);
//    }
//    self.screenImage.transform = transform;
//    self.screenImage.transform = CGAffineTransformRotate(self.screenImage.transform, M_PI_2);
//    
//}
//
//- (void)cutAction:(UIButton *)button {
//    RUNCutViewController *cutVC = [[RUNCutViewController alloc] init];
//    cutVC.imageData = self.imageData;
//    cutVC.delegate = self;
//    [self presentViewController:cutVC animated:NO completion:nil];
//}
//
//- (void)cutImage:(UIImage *)image {
//    self.screenImage.image = image;
//    self.imageData = image;
//    self.filterVC.imageData = image;
//}
//
//- (void)filterImage:(UIImage *)image {
//    self.screenImage.image = image;
//    self.imageData = image;
//}

@end
