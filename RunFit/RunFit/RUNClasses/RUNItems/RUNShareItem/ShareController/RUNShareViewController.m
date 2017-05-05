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
        make.width.equalTo(32);
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

#pragma - Button Action
- (void)p_closeButton:(UIButton *)button {
    if (self.isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)p_shareButton:(UIButton *)button {
    NSArray *cachePathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = cachePathArray[0];
    NSString *pathStr = [NSString stringWithFormat:@"%@/%@", cachePath, @"yxl_runImage.png"];
    
    NSData *imageData = UIImagePNGRepresentation(self.imageData);
    BOOL succeed = [imageData writeToFile:pathStr atomically:YES];
    if (!succeed) {
        NSLog(@"write data file error");
        return ;
    }
    
    NSURL *imageUrl = [NSURL fileURLWithPath:pathStr];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:@[imageUrl] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
