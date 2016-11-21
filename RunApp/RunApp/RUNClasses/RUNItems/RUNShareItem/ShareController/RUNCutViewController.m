//
//  RUNCutViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/20.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNCutViewController.h"
#import "UIViewController+ScreenShot.h"

@interface RUNCutViewController ()

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, assign) CGPoint       location;
@property (nonatomic, strong) UIView        *maskView;

@end

@implementation RUNCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setUI];
    [self p_setMask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI 
- (void)p_setUI {
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageData.size.width, self.imageData.size.height)];
    self.imageView.image = self.imageData;
    [self.view addSubview:self.imageView];
    
    UIButton *overButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [overButton setTitle:@"完成" forState:UIControlStateNormal];
    overButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    overButton.layer.borderWidth = 1.f;
    overButton.backgroundColor = [UIColor whiteColor];
    overButton.layer.borderColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1].CGColor;
    [overButton setTitleColor:[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1] forState:UIControlStateNormal];
    [overButton addTarget:self action:@selector(overButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:overButton];
    
    [overButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(ViewWidth / 2.0);
        make.height.equalTo(40);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    cancelButton.layer.borderWidth = 1.f;
    cancelButton.layer.borderColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1].CGColor;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.width.equalTo(ViewWidth / 2.0);
        make.height.equalTo(40);
    }];
}

- (void)p_setMask {
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewHeight - 40 - ViewHeight / 4.0 + 40, ViewWidth, ViewHeight / 4.0 - 40)];
    self.maskView.backgroundColor = [UIColor colorWithRed:216 / 255.0 green:216 / 255.0 blue:216 / 255.0 alpha:0.8];
    [self.view addSubview:self.maskView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
    lineView.backgroundColor = [UIColor clearColor];
    [self.maskView addSubview:lineView];
    
    UIPanGestureRecognizer *panGresture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTap:)];
    panGresture.minimumNumberOfTouches = 1;
    panGresture.maximumNumberOfTouches = 1;
    [lineView addGestureRecognizer:panGresture];
}

#pragma - Button Action
- (void)overButton:(UIButton *)button {
    UIImage *image = [self run_getScreenShotWithSize:CGSizeMake(ViewWidth, ViewHeight - self.maskView.frame.size.height - 40) view:self.view];
    if ([self.delegate respondsToSelector:@selector(cutImage:)]) {
        [self.delegate cutImage:image];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)cancelButton:(UIButton *)button {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Pan Gresture
- (void)panTap:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.location = [panGesture locationInView:panGesture.view.superview];
    }
    CGPoint afterLocation = [panGesture locationInView:panGesture.view.superview];
    CGFloat locationY = self.location.y - afterLocation.y;
    CGFloat originY = self.maskView.frame.origin.y - locationY > ViewHeight - 80 ? ViewHeight - 80: self.maskView.frame.origin.y - locationY;
    
    self.maskView.frame = CGRectMake(0, originY, ViewWidth, ViewHeight - originY - 40);
    
}

@end
