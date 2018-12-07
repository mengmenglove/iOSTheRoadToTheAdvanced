//
//  HBXImagePressViewController.m
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2018/12/7.
//  Copyright © 2018 黄保贤. All rights reserved.
//

#import "HBXImagePressViewController.h"
#import "UIImage+Resize.h"
#import "HBXPressImageShowViewController.h"


@interface HBXImagePressViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation HBXImagePressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)takePhotoFromCamera:(id)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.imagePicker.mediaTypes = @[@(UIImagePickerControllerSourceTypeCamera),];
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
    
    
}
- (IBAction)takePhotoFromLibrary:(id)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];

    
}

#pragma mark - imagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *_uploadImage = info[UIImagePickerControllerOriginalImage];
    [self compressImage:_uploadImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)compressImage:(UIImage *)image {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (image && image.size.width > 0) {
            NSLog(@"width: %f, height: %f",image.size.width, image.size.height);
            
            CGFloat newWith = 1080;
            CGFloat newHeight = newWith * image.size.height/image.size.width;
            UIImage *  newImage1 = [image resizedImage:CGSizeMake(newWith, newHeight) interpolationQuality:kCGInterpolationDefault];
            UIImage *  newImage2 = [image resizedImage:CGSizeMake(newWith, newHeight) interpolationQuality:kCGInterpolationNone];
            UIImage *  newImage3 = [image resizedImage:CGSizeMake(newWith, newHeight) interpolationQuality:kCGInterpolationLow];
            UIImage *  newImage4 = [image resizedImage:CGSizeMake(newWith, newHeight) interpolationQuality:kCGInterpolationMedium];
            UIImage *  newImage5 = [image resizedImage:CGSizeMake(newWith, newHeight) interpolationQuality:kCGInterpolationHigh];
            
            NSArray *array = @[newImage1, newImage2, newImage3, newImage4, newImage5];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.showImageView.image = image;
                HBXPressImageShowViewController *vc = [[HBXPressImageShowViewController alloc] initWithArray:array];
                [self.navigationController pushViewController:vc animated:YES];
            });
            //HBXPressImageShowViewController
        }
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
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
