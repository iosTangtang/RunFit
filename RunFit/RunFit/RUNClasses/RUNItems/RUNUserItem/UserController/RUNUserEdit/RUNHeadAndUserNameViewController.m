//
//  RUNHeadAndUserNameViewController.m
//  RunApp
//
//  Created by Tangtang on 2016/12/12.
//  Copyright © 2016年 Tangtang. All rights reserved.
//

#import "RUNHeadAndUserNameViewController.h"
#import "RunUserTableViewCell.h"
#import "RUNUserModel.h"
#import "SVProgressHUD.h"
#import <BmobSDK/BmobSDK.h>

static NSString *const kImageCell = @"RUNUserHeadCell";
static NSString *const kNameCell = @"RUNUserNameCell";

@interface RUNHeadAndUserNameViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong)   UITableView         *tableView;
@property (nonatomic, strong)   RUNUserModel        *userModel;
@property (nonatomic, strong)   UITextField         *textField;

@end

@implementation RUNHeadAndUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_setNavigationItem];
    [self p_setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RunUserTableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        NSData *imageData = [NSData dataWithContentsOfFile:[self p_getfilePath]];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image == nil) {
            image = [UIImage imageNamed:@"Oval 3"];
        }
        cell = [RunUserTableViewCell cellWith:tableView identifity:kImageCell];
        cell.userHeadImage.image = image;
    } else if(indexPath.row == 1) {
        cell = [RunUserTableViewCell cellWith:tableView identifity:kNameCell];
        self.textField = cell.nameTextField;
        self.textField.text = self.userModel.name;
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeyDone;
    } 
    
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 116;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self p_chooseImage];
    } else if (indexPath.row == 1) {
        if (self.textField) {
            [self.textField becomeFirstResponder];
        }
    }
    
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
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [SVProgressHUD showWithStatus:@"保存中.."];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    NSString *filePath = [self p_getfilePath];
    [imgData writeToFile:filePath atomically:YES];
    
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
    NSString *filePath = [self p_getfilePath];
    BmobUser *user = [BmobUser currentUser];
    BmobFile *file = [[BmobFile alloc] initWithFilePath:filePath];
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [user setUsername:self.textField.text];
            [user setObject:file forKey:@"headImage"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    self.userModel.name = self.textField.text;
                    [self.userModel saveData];
                    [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RUNHEADIMAGENOTIFICATION object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                   [SVProgressHUD showErrorWithStatus:@"保存失败"];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
        }
    }];
}

- (NSString *)p_getfilePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"headImage.jpg"];
    return filePath;
}

- (RUNUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[RUNUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}

@end
