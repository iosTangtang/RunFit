//
//  RUNHistoryMapViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/14.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNHistoryMapViewController.h"
#import "RUNShareViewController.h"
#import "RUNMapStopView.h"
#import "UIViewController+ScreenShot.h"
#import <MapKit/MapKit.h>

@interface RUNHistoryMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currlocation;

@end

@implementation RUNHistoryMapViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加mapView的约束
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(ViewHeight / 4.0 * 3);
    }];
    
    [self p_setHeadView];
    [self p_setValueView];
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
        make.left.equalTo(self.view.left).offset(5);
        make.width.equalTo(22);
        make.height.equalTo(22);
    }];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cameraButton setImage:[UIImage imageNamed:@"camera-map"] forState:UIControlStateNormal];
    [cameraButton setTintColor:[UIColor whiteColor]];
    [cameraButton addTarget:self action:@selector(p_cameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(23);
        make.right.equalTo(self.view.right).offset(-10);
        make.width.equalTo(25);
        make.height.equalTo(22);
    }];

    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"2016/11/04 22:22:22";
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(closeButton.top);
        make.height.equalTo(25);
    }];
}

- (void)p_setValueView {
    RUNMapStopView *stopView = [[RUNMapStopView alloc] initWithStopView:NO];
    stopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stopView];
    
    [stopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.mapView.bottom);
    }];
}

#pragma mark - MKMapViewDelegate
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currlocation = [locations lastObject];//获取当前位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currlocation.coordinate, 10000, 10000);
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - Button Action
- (void)p_closeButton:(UIButton *)button {
    if (self.isToRoot) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)p_cameraButton:(UIButton *)button {
    RUNShareViewController *shareVC = [[RUNShareViewController alloc] init];
    shareVC.isPush = YES;
    shareVC.imageData = [self run_getScreenShotWithSize:self.view.bounds.size view:self.view];
    [self.navigationController pushViewController:shareVC animated:YES];
}

- (MKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.zoomEnabled = YES;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [self.view addSubview:_mapView];
        
        UIBezierPath *bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ViewWidth, ViewHeight / 4.0 * 3)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezier.CGPath;
        layer.fillColor = [UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:0.6].CGColor;
        [_mapView.layer addSublayer:layer];
    }
    return _mapView;
}

- (CLLocationManager *)locationManager{
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;     //精度设置
        _locationManager.distanceFilter = 1000.0f;                      //设备移动后获得位置信息的最小距离
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];               //弹出用户授权对话框，使用程序期间授权
    }
    return _locationManager;
}

@end
