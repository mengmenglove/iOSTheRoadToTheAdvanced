//
//  HBXImageHandleViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/6/28.
//  Copyright © 2018年 黄保贤. All rights reserved.
//

#import "HBXImageHandleViewController.h"
#import "ImageFilterUtil.h"

#define  screen_width [UIScreen mainScreen].bounds.size.width
#define  screen_height [UIScreen mainScreen].bounds.size.height


@interface HBXImageHandleViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation HBXImageHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self creatUI];
    
    // Do any additional setup after loading the view.
}

- (void)creatUI {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake((screen_width - 40)/2  , 80, 40, 40);
    [btn addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((screen_width - 300)/2, 120, 300, 300);
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"黑白1" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake(0,500, 50, 50);
    [btn addTarget:self action:@selector(photoChange1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"黑白2" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake(60  ,500, 50, 50);
    [btn addTarget:self action:@selector(photoChange2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"黑白3" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake(120  ,500, 50, 50);
    [btn addTarget:self action:@selector(photoChange3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"黑白4" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake(180  ,500, 50, 50);
    [btn addTarget:self action:@selector(photoChange4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"彩色" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    btn.frame = CGRectMake(240  , 500, 50, 50);
    [btn addTarget:self action:@selector(phontoChangeBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)photoChange1 {
    UIImage *image = nil;
    image = [ImageFilterUtil grayscale:self.image type:1];
    self.imageView.image = image;
}

- (void)photoChange2 {
    UIImage *image = nil;
    image = [ImageFilterUtil grayscale:self.image type:2];
    self.imageView.image = image;
    
}


- (void)photoChange3 {
    UIImage *image = nil;
    image = [ImageFilterUtil grayscale:self.image type:3];
    self.imageView.image = image;
    
}

- (void)photoChange4 {
    UIImage *image = nil;
    image = [ImageFilterUtil grayscale:self.image type:4];
    self.imageView.image = image;
    
}


- (void)phontoChangeBack {
    
    self.imageView.image = self.image;
    
    
    
    
}



- (void)openPhoto {
    
    __weak typeof(self)  weakSelf = self;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takePhoto];
    }];
    UIAlertAction *choosePic = [UIAlertAction actionWithTitle:@"选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf choosePic];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:choosePic];
    [actionSheet addAction:cancel];

    [self presentViewController:actionSheet animated:true completion:nil];
    
    
  
    
}

- (void)takePhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:true completion:^{
        
    }];
}

- (void)choosePic {
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.image = image;
    self.imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
