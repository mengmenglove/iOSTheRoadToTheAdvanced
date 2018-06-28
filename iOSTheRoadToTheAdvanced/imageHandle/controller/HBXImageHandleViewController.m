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
@property (nonatomic, strong) NSArray *btnArray;

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
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    
    self.btnArray = @[@"黑白", @"黑白2",@"黑白3",@"黑白4",@"黑白5",@"黑白2",@"原色"];
    
    CGFloat originX = 10;
    CGFloat originY = 500;
    for(int i = 0 ; i < self.btnArray.count; i++){
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:self.btnArray[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(originX ,originY, 50, 50);
        [self.view addSubview:btn];
        originX += 60;
        if(screen_width - originX < 60)
        {
            originX = 10;
            originY = 500 + 60;
        }
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(photoChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}

- (void)photoChange:(UIButton *)sender {
    if(!self.image) {
        return;
    }
    UIImage *image = nil;
    NSInteger type = sender.tag - 100 + 1;
    if (type == 6) {
        image = self.image;
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage ];
        
        
        CIFilter *filter = [CIFilter filterWithName:@"CIConvolution3X3"];
        [filter setValue:ciImage forKey: kCIInputImageKey];
        
        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputBias"];
        CGFloat weights[] = {0,-1,0,
            -1,5,-1,
            0,-1,0};
        
//        CGFloat weights[] = {0.5,0,0,0,0,
//                                         0,0,0,0,0,
//                                         0,0,0,0,0,
//                                         0,0,0,0,0,
//            0,0,0,0,0.5};
        CIVector *inputWeights = [CIVector vectorWithValues:weights count:9];
        
        
        [filter setValue:inputWeights forKey:@"inputWeights"];
        
        
//
//        [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputBrightness"];
//        [filter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forKey:@"inputColor"];
//        [filter setValue:[NSNumber numberWithFloat:1.5] forKey:@"inputConcentration"];
//        CIVector *vect = [CIVector vectorWithX:200 Y:200 Z:0];
//        [filter setValue:vect forKey:@"inputLightPointsAt"];
//
//        vect = [CIVector vectorWithX:400 Y:600 Z:150];
//         [filter setValue:vect forKey:@"inputLightPosition"];
        
        
//        [filter setValue:[NSNumber numberWithFloat:200] forKey:@"inputWidth"];

        
        
        
//        [filter setValue:[NSNumber numberWithFloat:10] forKey:@"inputRadius"];
//        [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputSharpness"];
        
        
        
//
//        [filter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forKey:kCIInputColorKey];
//        [filter setValue:@1.0 forKey:kCIInputIntensityKey];
//
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outPutImage = filter.outputImage;
        CGImageRef newCIImage = [context createCGImage:outPutImage fromRect: outPutImage.extent];
        UIImage *resultImage = [UIImage imageWithCGImage:newCIImage scale:2.0 orientation:self.image.imageOrientation];
        CGImageRelease(newCIImage);
        self.imageView.image = resultImage;
    }else if(type != self.btnArray.count) {
        image = [ImageFilterUtil grayscale:self.image type:sender.tag - 100 + 1];
        self.imageView.image = image;
    }else {
         self.imageView.image = self.image;
    }
}
/*
 /**
 
 CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"] ;
 [filter setValue:ciImage forKey: kCIInputImageKey];
 [filter setValue:[NSNumber numberWithFloat:0.3] forKey: @"inputSaturation"];
 [filter setValue:[NSNumber numberWithFloat:0.3] forKey:@"inputBrightness"];
 [filter setValue:[NSNumber numberWithFloat:2] forKey:@"inputContrast"];
 */


/*
 //黑白处理
 CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
 [filter setValue:ciImage forKey: kCIInputImageKey];
 [filter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forKey:kCIInputColorKey];
 [filter setValue:@1.0 forKey:kCIInputIntensityKey];
 
 */

/**
 降噪音
 CIFilter *filter = [CIFilter filterWithName:@"CINoiseReduction"];
 [filter setValue:ciImage forKey: kCIInputImageKey];
 [filter setValue:[NSNumber numberWithFloat:0.02] forKey:@"inputNoiseLevel"];
 [filter setValue:[NSNumber numberWithFloat:0.4] forKey:@"inputSharpness"];
 
 */


/**
 清楚明亮
 CIFilter *filter = [CIFilter filterWithName:@"CISharpenLuminance"];
 [filter setValue:ciImage forKey: kCIInputImageKey];
 //        [filter setValue:@"CICategoryStillImage" forKey:@"CIAttributeFilterCategories"];
 [filter setValue:[NSNumber numberWithFloat:10] forKey:@"inputRadius"];
 [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputSharpness"];
 */

/**
 
 条纹发电机
 CIFilter *filter = [CIFilter filterWithName:@"CIStripesGenerator"];
 [filter setValue:ciImage forKey: kCIInputImageKey];
 
 CIVector *vol = [CIVector vectorWithX:150 Y:150];
 [filter setValue:vol forKey:@"inputCenter"];
 [filter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forKey:@"inputColor0"];
 [filter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forKey:@"inputColor1"];
 [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputSharpness"];
 [filter setValue:[NSNumber numberWithFloat:200] forKey:@"inputWidth"];
 
 */





- (void)phontoChangeBack {
    if(!self.image) {
        return;
    }
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
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:true completion:^{
        
    }];
    
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
