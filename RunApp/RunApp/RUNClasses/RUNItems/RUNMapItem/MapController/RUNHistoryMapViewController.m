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

@property (nonatomic, strong) MKMapView     *mapView;
@property (nonatomic, strong) MKPolyline    *routeLine;

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
    
    
    [self p_setMap];
    [self p_setHeadView];
    [self p_setValueView];
    [self p_loadRoute];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set UI Method
- (void)p_setMap {
    //添加mapView的约束
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(ViewHeight / 4.0 * 3);
    }];
    
    CLLocationCoordinate2D coordinate = [self p_stringToCoor:[self.lineDatas firstObject]];
    CLLocationCoordinate2D lastCoor = [self p_stringToCoor:[self.lineDatas lastObject]];
    CGFloat distance = sqrt(pow(lastCoor.latitude - coordinate.latitude, 2) + pow(lastCoor.longitude - coordinate.longitude, 2));
    CLLocationCoordinate2D locaCoor = CLLocationCoordinate2DMake((coordinate.latitude + lastCoor.latitude) / 2.0,
                                                                 (coordinate.longitude + lastCoor.longitude) / 2.0);
    distance = distance < 10 ? distance * 750 : distance;
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(locaCoor, distance, distance)];
}

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
    timeLabel.text = self.dateTitle;
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
    stopView.isRun = self.isRun;
    stopView.datas = self.datas;
    [self.view addSubview:stopView];
    
    [stopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.mapView.bottom);
    }];
}

#pragma mark - Load Route
- (void)p_loadRoute {
    MKMapPoint *routeArray = (MKMapPoint *)malloc(sizeof(CLLocationCoordinate2D) * self.lineDatas.count);
    
    for (int index = 0; index < self.lineDatas.count; index++) {
        NSString *obj = self.lineDatas[index];
        NSArray *coors = [obj componentsSeparatedByString:@","];
        CLLocationDegrees latitude = [coors[0] doubleValue];
        CLLocationDegrees longitude = [coors[1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        routeArray[index] = point;
        
        // 添加起始和结束位置的大头针
        if (index == 0) {
            MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
            point.coordinate = coordinate;
            point.title = @"起始位置";
            [self.mapView addAnnotation:point];
        } else if (index == self.lineDatas.count - 1) {
            MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
            point.coordinate = coordinate;
            point.title = @"结束位置";
            [self.mapView addAnnotation:point];
        }
    }
    self.routeLine =  [MKPolyline polylineWithPoints:routeArray count:self.lineDatas.count];
    
    free(routeArray);
    
    [self.mapView addOverlay:self.routeLine];
}

#pragma mark - MKMapViewDelegate
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor colorWithRed:25 / 255.0 green:232 / 255.0 blue:100 / 255.0 alpha:1];
    renderer.lineWidth = 8.0;
    
    return  renderer;
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

#pragma mark - String To Coor
- (CLLocationCoordinate2D)p_stringToCoor:(NSString *)str {
    NSArray *coors = [str componentsSeparatedByString:@","];
    CLLocationDegrees latitude = [coors[0] doubleValue];
    CLLocationDegrees longitude = [coors[1] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return coordinate;
}

- (MKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.zoomEnabled = YES;
        _mapView.delegate = self;
        _mapView.showsUserLocation = NO;
        [self.view addSubview:_mapView];
        
        UIBezierPath *bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ViewWidth, ViewHeight / 4.0 * 3)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezier.CGPath;
        layer.fillColor = [UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:0.6].CGColor;
        [_mapView.layer addSublayer:layer];
    }
    return _mapView;
}

@end
