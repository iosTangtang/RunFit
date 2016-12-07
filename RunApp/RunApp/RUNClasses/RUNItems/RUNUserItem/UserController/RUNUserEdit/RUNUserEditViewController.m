//
//  RUNUserEditViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/11/13.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNUserEditViewController.h"
#import "RunUserTableViewCell.h"
#import "RUNPickViewController.h"
#import "SVProgressHUD.h"
#import "RUNUserModel.h"

static NSString *const kImageCell = @"RUNUserHeadCell";
static NSString *const kNameCell = @"RUNUserNameCell";
static NSString *const kNormalCell = @"RUNUserNormalCell";

@interface RUNUserEditViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
                                        RUNPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSInteger _row;
}

@property (nonatomic, strong)   UITableView         *tableView;
@property (nonatomic, copy)     NSArray             *titles;
@property (nonatomic, strong)   UITextField         *textField;
@property (nonatomic, strong)   NSMutableArray      *datas;
@property (nonatomic, strong)   NSMutableArray      *stands;
@property (nonatomic, strong)   RUNUserModel        *userModel;

@end

@implementation RUNUserEditViewController

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"性别", @"体重", @"身高", @"我的步数目标"];
    }
    return _titles;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] initWithArray:@[self.userModel.sex, self.userModel.weight, self.userModel.height, self.userModel.tag]];
    }
    return _datas;
}

- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}

- (NSMutableArray *)stands {
    if (!_stands) {
        NSMutableArray *weight1 = [NSMutableArray array];
        NSMutableArray *weight2 = [NSMutableArray array];
        NSMutableArray *height = [NSMutableArray array];
        NSMutableArray *tags = [NSMutableArray array];
        for (int index = 50; index < 251; index++) {
            [height addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 25; index < 251; index++) {
            [weight1 addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 0; index < 10; index++) {
            [weight2 addObject:[NSString stringWithFormat:@"%d", index]];
        }
        for (int index = 1000; index < 21000; index += 1000) {
            [tags addObject:[NSString stringWithFormat:@"%d", index]];
        }
        _stands = [[NSMutableArray alloc] initWithObjects:@[@[@"男", @"女"]], @[weight1, weight2, @[@"kg"]], @[height, @[@"cm"]], @[tags], nil];
    }
    return _stands;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setNavigationItem];
    [self p_setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Item
- (void)p_setNavigationItem {
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(p_overAction:)];
    self.navigationItem.rightBarButtonItem = right;
}

#pragma mark - Set TableView
- (void)p_setupTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - Camera Operation
- (void)p_chooseImage {
    UIImagePickerController * imgpickVC =[[UIImagePickerController alloc] init];
    imgpickVC.delegate =self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        imgpickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imgpickVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        [self presentViewController:imgpickVC animated:YES completion:^{}];
    }];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imgpickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgpickVC animated:YES completion:^{}];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userModel.isLogin ? 6 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RunUserTableViewCell *cell = nil;
    
    if (indexPath.row == 0 && self.userModel.isLogin) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *imageData = [defaults objectForKey:@"userIcon"];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image == nil) {
            image = [UIImage imageNamed:@"Oval 3"];
        }
        cell = [RunUserTableViewCell cellWith:tableView identifity:kImageCell];
        cell.userHeadImage.image = image;
    } else if(indexPath.row == 1 && self.userModel.isLogin) {
        cell = [RunUserTableViewCell cellWith:tableView identifity:kNameCell];
        self.textField = cell.nameTextField;
        self.textField.text = self.userModel.name;
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeyDone;
    } else {
        NSUInteger index = 0;
        if (self.userModel.isLogin) {
            index = indexPath.row - 2;
        } else {
            index = indexPath.row;
        }
        cell = [RunUserTableViewCell cellWith:tableView identifity:kNormalCell];
        cell.titleLabel.text = self.titles[index];
        cell.valueLabel.text = self.datas[index];
    }
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.userModel.isLogin) {
        return 116;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![self.userModel.isLogin boolValue]) {
        _row = indexPath.row;
        [self p_initPickerView:indexPath.row];
        return;
    }
    
    if (indexPath.row == 0) {
        [self p_chooseImage];
    } else if (indexPath.row == 1) {
        if (self.textField) {
            [self.textField becomeFirstResponder];
        }
    } else {
        _row = indexPath.row - 2;
        [self p_initPickerView:indexPath.row - 2];
    }
    
}

- (void)p_initPickerView:(NSUInteger)row {
    RUNPickViewController *pick = [[RUNPickViewController alloc] init];
    pick.pickDelegate = self;
    pick.backGroundColor = [UIColor whiteColor];
    pick.datas = self.stands[row];
    pick.mainTitle = self.titles[row];
    pick.separator = @".";
    if (row == 0) {
        NSString *value = @"0";
        if ([self.userModel.sex isEqualToString:@"女"]) {
            value = @"1";
        }
        pick.defaultData = @[value];
        pick.dValue = @[@"0"];
    } else if (row == 1) {
        NSString *weight = [[self.userModel.weight componentsSeparatedByString:@"kg"] firstObject];
        pick.defaultData = [weight componentsSeparatedByString:@"."];
        pick.dValue = @[@"25", @"0"];
    } else if (row == 2) {
        NSString *height = [[self.userModel.height componentsSeparatedByString:@"c"] firstObject];
        pick.defaultData = @[height];
        pick.dValue = @[@"50"];
    }
    
    pick.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:pick animated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textField resignFirstResponder];
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.userModel.name = textField.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - RUNPickerViewDelegate
- (void)pickText:(NSString *)text {
    [self.datas replaceObjectAtIndex:_row withObject:text];
    [self.tableView reloadData];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithStatus:@"保存中.."];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    [defaults setObject:imgData forKey:@"userIcon"];
    [defaults synchronize];
    
    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
    
    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil){
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:RUNHEADIMAGENOTIFICATION object:nil];
        [self.tableView reloadData];
        
    } else {
        NSLog(@"An error happened while saving the image. error = %@", error);
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
    }
}

#pragma mark - Over Action
- (void)p_overAction:(UIBarButtonItem *)barButton {
    [SVProgressHUD showWithStatus:@"保存中.."];
    self.userModel.name = self.textField.text;
    self.userModel.sex = self.datas[0];
    self.userModel.weight = self.datas[1];
    self.userModel.height = self.datas[2];
    self.userModel.tag = self.datas[3];
    [self.userModel saveData];
    [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    [[NSNotificationCenter defaultCenter] postNotificationName:RUNHEADIMAGENOTIFICATION object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
