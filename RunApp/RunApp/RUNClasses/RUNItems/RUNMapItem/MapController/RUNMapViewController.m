//
//  RUNMapViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/12.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNMapViewController.h"
#import "RUNHistoryViewController.h"
#import "RUNHistoryMapViewController.h"
#import "RUNMapStartView.h"
#import "RUNMapStopView.h"
#import <MapKit/MapKit.h>

@interface RUNMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, RUNMapStartDelegate, RUNMapStopDelegate> {
    BOOL _isRun;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currlocation;
@property (nonatomic, strong) RUNMapStartView *mapStartView;

@end

@implementation RUNMapViewController

- (MKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.zoomEnabled = YES;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [self.view addSubview:_mapView];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setNavigationItem];
    [self p_setMapView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set Map
- (void)p_setMapView {
    self.mapStartView = [[RUNMapStartView alloc] init];
    self.mapStartView.delegate = self;
    [self.view addSubview:self.mapStartView];
    
    [self.mapStartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(ViewHeight / 3);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mapStartView.top);
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

#pragma mark - RUNMapStartDelegate
- (void)startButtonClick:(NSInteger)selected {
    _isRun = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    RUNMapStopView *stopView = [[RUNMapStopView alloc] initWithStopView:YES];
    stopView.delegate = self;
    [self.view addSubview:stopView];
    [stopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(ViewHeight / 3);
    }];
    
    [self.mapView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(stopView.top);
    }];
    
    stopView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.mapStartView.alpha = 0;
        stopView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.mapStartView removeFromSuperview];
    }];
}

#pragma mark - RUNMapStopDelegate
- (void)stopButtonClick:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否保存数据？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        RUNHistoryMapViewController *hisMapVC = [[RUNHistoryMapViewController alloc] init];
        hisMapVC.isToRoot = YES;
        [weakSelf.navigationController pushViewController:hisMapVC animated:YES];
    }];
    [alert addAction:yesAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController setNavigationBarHidden:NO];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation Item
- (void)p_setNavigationItem {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"历史记录"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(p_overAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - Over Action
- (void)p_overAction:(UIBarButtonItem *)barButton {
    RUNHistoryViewController *historyVC = [[RUNHistoryViewController alloc] init];
    historyVC.title = @"运动记录";
    [self.navigationController pushViewController:historyVC animated:YES];
}

@end
