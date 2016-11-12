//
//  ViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/3.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNViewController.h"
#import <HealthKit/HealthKit.h>

@interface RUNViewController ()

@property (nonatomic, strong) HKHealthStore *healthStore;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;

@end

@implementation RUNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)healthButton:(id)sender {
    //判断设备是否支持HealthKit，iPad不支持
    if (![HKHealthStore isHealthDataAvailable]) {
        NSLog(@"设备不支持healthKit");
    }
    
    self.healthStore = [[HKHealthStore alloc] init];
    
    //设置需要获取的权限
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
    
    //从健康中获取权限
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"获取步数权限成功");
            [self readStepCount];
        }
        else {
            NSLog(@"获取步数权限失败");
        }
    }];
}

- (void)readStepCount {
    //查询采样信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //排序方法
    NSSortDescriptor *startSort = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *endSort = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calender components:flags fromDate:nowDate];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    NSDate *nowDay = [NSDate dateWithTimeIntervalSinceNow:-(hour * 3600 + minute * 60 + second)];
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:86400 - (hour * 3600 + minute * 60 + second)];
    
    NSLog(@"%@ %@ %@", nowDay, nextDay, nowDate);
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:nowDay endDate:nextDay options:HKQueryOptionNone];
    
    /*
     * 查询的基类是HKQuery，这是一个抽象类，能够实现每一种查询目标，这里我们需要查询的步数是一个
     * HKSample类所以对应的查询类就是HKSampleQuery。
     * 下面的limit参数传1表示查询最近一条数据,查询多条数据只要设置limit的参数值就可以了
     */
    
//    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:10 sortDescriptors:@[startSort, endSort] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
//        
//        //打印查询结果
//        NSLog(@"resultCount = %ld result = %@", results.count, results);
//
//        //把结果转换成字符串类型
//        if (results.count > 0) {
//            
//            int allStepCount = 0;
//            for (HKQuantitySample *result in results) {
//                HKQuantity *quantity = result.quantity;
//                NSString *stepStr = [NSString stringWithFormat:@"%@", quantity];
//                NSString *step = [[stepStr componentsSeparatedByString:@" "] firstObject];
//                allStepCount += [step intValue];
//                
//                NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:result.endDate];
//                NSDate *startDate = [result.startDate dateByAddingTimeInterval:interval];
//                NSDate *endDate = [result.endDate dateByAddingTimeInterval:interval];
//                
//                NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
//                [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                
//                NSLog(@"%@ %@ %@ %@", [dateFormater stringFromDate:startDate], [dateFormater stringFromDate:endDate],
//                      [dateFormater stringFromDate:result.startDate], [dateFormater stringFromDate:result.endDate]);
//            }
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"步数 ： %d", allStepCount);
//                self.stepLabel.text = [NSString stringWithFormat:@"%d", allStepCount];
//            });
//        }
//        
//    }];
    
    
    HKQuantityType *quantity = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantity quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        NSLog(@"health = %@",result);
        HKQuantity *sum = [result sumQuantity];
        
        double value = [sum doubleValueForUnit:[HKUnit kilocalorieUnit]];
        NSLog(@"卡路里 ---> %.2lf",value);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stepLabel.text = [NSString stringWithFormat:@"%.1lf kcal", value];
        });
    }];
    
    
    //执行查询
    [self.healthStore executeQuery:query];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
