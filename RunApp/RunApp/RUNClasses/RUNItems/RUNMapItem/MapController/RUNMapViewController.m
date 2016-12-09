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
#import "RUNUserModel.h"
#import "CLLocation+Sino.h"
#import <MapKit/MapKit.h>
#import <CoreMotion/CoreMotion.h>

@interface RUNMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, RUNMapStartDelegate, RUNMapStopDelegate> {
    BOOL _isRun;
    NSInteger _second;
    NSInteger _mintue;
    NSInteger _selected;
}

@property (nonatomic, strong) MKMapView             *mapView;
@property (nonatomic, strong) CLLocationManager     *locationManager;
@property (nonatomic, strong) CLLocation            *currlocation;
@property (nonatomic, strong) RUNMapStartView       *mapStartView;
@property (nonatomic, strong) NSMutableArray        *lineArray;
@property (nonatomic, strong) MKPolyline            *routeLine;
@property (nonatomic, strong) NSTimer               *timer;
@property (nonatomic, strong) RUNUserModel          *userModel;
@property (nonatomic, strong) RUNMapStopView        *stopView;
@property (nonatomic, strong) CMPedometer           *cmPedometer;

@end

@implementation RUNMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_setNavigationItem];
    [self p_setMapView];
    [self p_startLocation];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)p_startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"error");
    }
    
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

#pragma mark - Set StopView
- (void)p_setStopView:(NSInteger)selected {
    self.stopView = [[RUNMapStopView alloc] initWithStopView:YES];
    self.stopView.delegate = self;
    self.stopView.isRun = !selected;
    _selected = !selected;
    [self.view addSubview:self.stopView];
    [self.stopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(ViewHeight / 3);
    }];
    
    [self.mapView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.stopView.top);
    }];
    
    self.stopView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.mapStartView.alpha = 0;
        self.stopView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.mapStartView removeFromSuperview];
    }];
}

#pragma mark - MKMapViewDelegate
//地图覆盖物的代理方法
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithRed:25 / 255.0 green:232 / 255.0 blue:100 / 255.0 alpha:1];
    renderer.lineWidth = 8.0;
    
    return  renderer;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currlocation = [locations firstObject];
    
    if (![self.currlocation run_isLocationOutOfChina:[self.currlocation coordinate]]) {
        self.currlocation = [self.currlocation locationMarsFromEarth];
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.currlocation coordinate], 2500, 2500);
    [self.mapView setRegion:region animated:YES];
    
    if (_isRun) {
        [self.lineArray addObject:[NSString stringWithFormat:@"%f, %f", [self.currlocation coordinate].latitude,
                                   [self.currlocation coordinate].longitude]];
        if (self.routeLine != nil) {
            self.routeLine = nil;
        }
        [self p_loadRoute];
        if (self.routeLine != nil) {
            [self.mapView addOverlay:self.routeLine];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - RUNMapStartDelegate
- (void)startButtonClick:(NSInteger)selected {
    [self.locationManager stopUpdatingLocation];
    _isRun = YES;
    [self.locationManager startUpdatingLocation];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self p_setStopView:selected];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(p_startTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [self p_startStep];
}

#pragma mark - RUNMapStopDelegate
- (void)stopButtonClick:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    UIAlertAction *noAction = nil;
    UIAlertAction *yesAction = nil;
    NSString *message = nil;
    if (self.lineArray.count <= 0) {
        message = @"无法保存数据,是否继续?";
        yesAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:nil];
        
    } else {
        message = @"是否保存数据?";
        yesAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            RUNHistoryMapViewController *hisMapVC = [[RUNHistoryMapViewController alloc] init];
            hisMapVC.isToRoot = YES;
            hisMapVC.isRun = _selected;
            hisMapVC.datas = self.stopView.datas;
            hisMapVC.lineDatas = self.lineArray;
            [weakSelf.navigationController pushViewController:hisMapVC animated:YES];
        }];
        
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    noAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController setNavigationBarHidden:NO];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf.timer invalidate];
        [weakSelf.cmPedometer stopPedometerUpdates];
    }];
    [alert addAction:noAction];
    [alert addAction:yesAction];
    
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

#pragma mark - Start Timing
- (void)p_startTime {
    _second++;
    if (_second == 60) {
        _second = 0;
        _mintue++;
    }
    NSString *secondStr = (_second >= 10) ? [NSString stringWithFormat:@"%ld", (long)_second] :
                                            [NSString stringWithFormat:@"0%ld", (long)_second];
    NSString *mintueStr = (_mintue >= 10) ? [NSString stringWithFormat:@"%ld", (long)_mintue] :
                                            [NSString stringWithFormat:@"0%ld", (long)_mintue];
    NSMutableArray *stopViewData = [NSMutableArray arrayWithArray:self.stopView.datas];
    [stopViewData replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@:%@", mintueStr, secondStr]];
    self.stopView.datas = stopViewData;
}

#pragma mark - Start Steping
- (void)p_startStep {
    [self.cmPedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *disCount = [NSString stringWithFormat:@"%.1f", [pedometerData.distance doubleValue] / 1000];
            NSString *lastCount = nil;
            if ((!_selected) == 0) {
                lastCount = [NSString stringWithFormat:@"%@", pedometerData.numberOfSteps];
            } else {
                lastCount = [NSString stringWithFormat:@"%.1f", [pedometerData.averageActivePace doubleValue]];
            }
            NSString *energy = [NSString stringWithFormat:@"%.0f", [self.userModel.weight doubleValue] *
                                                                        ([pedometerData.distance doubleValue] / 1000) * 1.036];
            NSArray *datas = @[self.stopView.datas[0], disCount, energy, lastCount];
            self.stopView.datas = datas;
            
        });
    }];
}

#pragma mark - Over Action
- (void)p_overAction:(UIBarButtonItem *)barButton {
    RUNHistoryViewController *historyVC = [[RUNHistoryViewController alloc] init];
    historyVC.title = @"运动记录";
    [self.navigationController pushViewController:historyVC animated:YES];
}

#pragma mark - Load Route
- (void)p_loadRoute {

    MKMapPoint *routeArray = (MKMapPoint *)malloc(sizeof(CLLocationCoordinate2D) * self.lineArray.count);
    
    for (int index = 0; index < self.lineArray.count; index++) {
        NSString *obj = self.lineArray[index];
        NSArray *coors = [obj componentsSeparatedByString:@","];
        CLLocationDegrees latitude = [coors[0] doubleValue];
        CLLocationDegrees longitude = [coors[1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        routeArray[index] = point;
    }
    self.routeLine =  [MKPolyline polylineWithPoints:routeArray count:self.lineArray.count];
    
    free(routeArray);
}

#pragma mark - Lazy Load
- (MKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.zoomEnabled = YES;
        _mapView.delegate = self;
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        _mapView.showsUserLocation = YES;
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;     //精度设置
        _locationManager.distanceFilter = kCLDistanceFilterNone;        //设备移动后获得位置信息的最小距离
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];                  //弹出用户授权对话框，使用程序期间授权
    }
    return _locationManager;
}

- (CMPedometer *)cmPedometer {
    if (!_cmPedometer) {
        _cmPedometer = [[CMPedometer alloc] init];
    }
    return _cmPedometer;
}

- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}


- (NSMutableArray *)lineArray {
    if (!_lineArray) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}

@end
