//
//  UIImage+Addtional.m
//  RenrenOfficial-iOS-Concept
//
//  Created by sunyuping on 13-6-21.
//  Copyright (c) 2013年 renren. All rights reserved.
//

#import "UIImage+Addtional.h"
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

static void AddRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
								 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@implementation UIImage (RNAdditions)

+ (UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size {
    if (!image) {
        return nil;
    }
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size,NO, 0.0f);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage*)clipImage:(UIImage *)originalImage rect:(CGRect)rect
{
    if (!originalImage) {
        return nil;
    }

    CGFloat scale = [UIScreen mainScreen].scale;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, CGRectMake(0, 0, rect.size.width * scale, rect.size.height * scale));
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    return smallImage;
}

//截取部分图像(区分高分屏或者低分屏)
+ (UIImage*)getSubImage:(UIImage *)img scale:(CGFloat)scale rect:(CGRect)rect
{
    if (!img) {
        return nil;
    }

    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    // 此处有可能生成的图片比需要生成的图片大，故作以下判断  zhengzheng
    if(!CGSizeEqualToSize(smallBounds.size, rect.size))
    {
        CGImageRelease(subImageRef);
        subImageRef = nil;
        int wOffset = smallBounds.size.width - rect.size.width;
        int hOffset = smallBounds.size.height - rect.size.height;
        rect.size.width = rect.size.width - wOffset;
        rect.size.height = rect.size.height - hOffset;
        subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
        smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    }
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    //    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef scale:scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    return smallImage;
}

+ (UIImage*)middleStretchableImageWithKey:(NSString*)key {
    UIImage *image = [UIImage imageForKey:key];
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

//中间拉伸图片,不支持换肤
+ (UIImage *)middleStretchableImageWithOutSupportSkin:(NSString *)key {
    UIImage *image = [UIImage imageNamed:key];
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

/*create round rect UIImage with the specific size*/
+ (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size cornerRadius:(CGFloat)radius
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    AddRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *imageMask = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return imageMask;
	
}
//等比缩放
+ (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize {
    CGFloat width = floorf(image.size.width * scaleSize);
    CGFloat height = floorf(image.size.height * scaleSize);
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    RR_DMLog(@"syp===scaledImage===size==%f,%f",scaledImage.size.width,scaledImage.size.height);
    return scaledImage;
}
// 缩放图片并且从上段截取
+ (UIImage *)topScaleImage:(UIImage *)image scaleToSize:(CGSize)size{
    //    RR_DMLog(@"syp===00000===size==%f,%f",image.size.width,image.size.height);
    float scaleSize = 0.0;
    float screenScale = [UIScreen mainScreen].scale;
    CGSize imagesize = [image size];
    if (imagesize.width >= imagesize.height) {
        scaleSize = size.height/imagesize.height * screenScale;
    }else{
        scaleSize = size.width/imagesize.width * screenScale;
    }
    UIImage *currentimage = [UIImage scaleImage:image toScale:scaleSize];
    CGRect currentfram = CGRectMake(0, 0, size.width, size.height);
    // 返回新的改变大小后的图片
    return [UIImage clipImage:currentimage rect:currentfram];
}

// 缩放图片并且剧中截取
+ (UIImage *)middleScaleImage:(UIImage *)image scaleToSize:(CGSize)size{
//    RR_DMLog(@"syp===00000===size==%f,%f",image.size.width,image.size.height);
    float scaleSize = 0.0;
    float screenScale = [UIScreen mainScreen].scale;
    CGSize imagesize = [image size];
    if (imagesize.width >= imagesize.height) {
        scaleSize = size.height/imagesize.height * screenScale;
    }else{
        scaleSize = size.width/imagesize.width * screenScale;
    }
    UIImage *currentimage = [UIImage scaleImage:image toScale:scaleSize];
    CGRect currentfram = CGRectMake((currentimage.size.width - size.width)/2, (currentimage.size.height - size.height)/2, size.width, size.height);
    
    // 返回新的改变大小后的图片
    return [UIImage clipImage:currentimage rect:currentfram];
}

//宽高取小缩放，取大居中截取
+ (UIImage *)suitableScaleImage:(UIImage *)image scaleToSize:(CGSize)size
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGSize imageSize = image.size;
    CGFloat realScale = 0.0f;
    UIImage *tmpImage = nil;
    CGFloat imageSizeMax = MAX(imageSize.width, imageSize.height);
    CGFloat imageSizeMin = MIN(imageSize.width, imageSize.height);
    
    //短边大于定长
    if ( imageSizeMin >= size.width/* * screenScale*/ ) {
        if ( imageSize.width <= imageSize.height ) {
            realScale = size.width / imageSize.width * screenScale;
            UIImage *currentImage = [UIImage scaleImage:image toScale:realScale];
            tmpImage = [UIImage getSubImage:currentImage scale:screenScale rect:CGRectMake(0, ( currentImage.size.height - size.height * screenScale ) / 2.0f, size.width * screenScale, size.height *screenScale)];
        }
        else
        {
            realScale = size.height / imageSize.height * screenScale;
            UIImage *currentImage = [UIImage scaleImage:image toScale:realScale];
            tmpImage = [UIImage getSubImage:currentImage scale:screenScale rect:CGRectMake( ( currentImage.size.width - size.width * screenScale ) / 2.0f, 0, size.width * screenScale, size.height * screenScale)];
        }
    }
    else
    {   //短边小于定长，长边大于定长
        if ( imageSizeMax > size.width/* * screenScale*/ ) {
            if ( imageSize.width < imageSize.height ) {
                tmpImage = [UIImage getSubImage:image scale:screenScale rect:CGRectMake(0, ( imageSize.height - size.height * screenScale ) / 2.0f, size.width * screenScale, size.height *screenScale)];
            }
            else
            {
                tmpImage = [UIImage getSubImage:image scale:screenScale rect:CGRectMake( ( imageSize.width - size.width * screenScale ) / 2.0f, 0, size.width * screenScale, size.height * screenScale)];
            }
        }
        else //长短边都小于定长
        {
            tmpImage = image;
        }
    }
    
    return tmpImage;
}

//等比例缩放
+(UIImage*)scaleToSize:(UIImage*)image size:(CGSize)size
{
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
+ (UIImage *)compressImage:(UIImage *)image maxLength:(NSInteger)maxLength{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSInteger count = 0;
    while (data.length > maxLength && count < 6) {
        data = UIImageJPEGRepresentation(image, 0.7);
        image = [UIImage imageWithData:data];
        count++;
    }
    
    return image;
}
- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 判断是否超长超宽图（宽高比大于4）
+ (BOOL)isLongwidePhoto:(UIImage*)image
{
    if (image) {
        CGFloat oWidth = image.size.width;
        CGFloat oHeight = image.size.height;
        if ((oWidth / oHeight) > (10/3) || (oHeight / oWidth) > (10/3))
            return YES;
        else
            return NO;
    }
    
    return NO;
}

// 将宽高比大于4的图，截取顶部的宽高 1：2 的部分
+ (UIImage*)longwidePhotoToNormal:(UIImage*)image
{
    if (image) {
        CGFloat oWidth = image.size.width;
        CGFloat oHeight = image.size.height;
        
        CGRect frame = CGRectZero;
        
        if (oWidth > oHeight)
            frame.size = CGSizeMake(oHeight * 2, oHeight);
        else
            frame.size = CGSizeMake(oWidth, oWidth * 2);
        
        return [UIImage clipImage:image rect:frame];
    }
    
    return nil;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)imageForRHCButton:(UIColor *)backColor border:(UIColor *)borderColor shadow:(UIColor *)shadowColor radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth withFrame:(CGRect)frame
{
    int power = [UIScreen mainScreen].scale;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width * power, (frame.size.height + 2) * power)];
    [buttonView setBackgroundColor:[UIColor clearColor]];

    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, buttonView.height - 10 * power, buttonView.width, 10* power)];
    [shadowView.layer setCornerRadius:radius * power];
    [shadowView.layer setBorderColor:shadowColor.CGColor];
    [shadowView.layer setBorderWidth:6.0f];
    [shadowView setBackgroundColor:[UIColor clearColor]];
    [buttonView addSubview:shadowView];

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width * power, frame.size.height * power)];
    [contentView.layer setCornerRadius:radius * power];
    [contentView setBackgroundColor:backColor];

//    UIView *borderView = [[UIView alloc]initWithFrame:contentView.bounds];
//    [borderView setBackgroundColor:[UIColor clearColor]];
    [contentView.layer setBorderWidth:borderWidth * power];
    [contentView.layer setBorderColor:borderColor.CGColor];
    [contentView.layer setCornerRadius:radius * power];
//    [contentView addSubview:borderView];
    [buttonView addSubview:contentView];

    UIGraphicsBeginImageContext(buttonView.bounds.size);
    [buttonView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//+(UIColor *)getColorWithImage:(UIImage *)image{
//
//    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
//    CGSize thumbSize=CGSizeMake(50, 50);
//    //kCGImageAlphaPremultipliedLast
//    int bitmapInfo = 1;
//
//    bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
//
//
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(NULL,
//                                                 thumbSize.width,
//                                                 thumbSize.height,
//                                                 8,//bits per component
//                                                 thumbSize.width*4,
//                                                 colorSpace,
//                                                 bitmapInfo);
//
//    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
//    CGContextDrawImage(context, drawRect, image.CGImage);
//    CGColorSpaceRelease(colorSpace);
//
//
//
//    //第二步 取每个点的像素值
//    unsigned char* data = CGBitmapContextGetData (context);
//
//    float redTotal = 0;
//    float greenTotal = 0;
//    float blueTotal = 0;
//
//    if (data == NULL) return nil;
//
//  //  NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
//
//    for (int x=0; x<thumbSize.width; x++) {
//        for (int y=0; y<thumbSize.height; y++) {
//
//            int offset = 4*(x*y);
//
//            int red = data[offset];
//            int green = data[offset+1];
//            int blue = data[offset+2];
//
//            redTotal += red;
//            greenTotal += green;
//            blueTotal += blue;
//
////            NSArray *clr=@[@(red),@(green),@(blue)];
////            [cls addObject:clr];
//
//        }
//    }
//
//
//    CGContextRelease(context);
//    //计算平均值
//    int total = 50 *50;
//    redTotal/=total;
//    greenTotal/=total;
//    blueTotal/=total;
////    NSEnumerator *enumerator = [cls objectEnumerator];
////    NSArray *curColor = nil;
////
////    NSArray *MaxColor=nil;
////    NSUInteger MaxCount=0;
////
////    while ( (curColor = [enumerator nextObject]) != nil )
////    {
////        NSUInteger tmpCount = [cls countForObject:curColor];
////
////        if ( tmpCount < MaxCount ) continue;
////
////        MaxCount=tmpCount;
////        MaxColor=curColor;
////
////    }
//
//    HSVObj *hsvO = [UIColor rgbToHSV:redTotal green:greenTotal blue:blueTotal];
//    if ((hsvO.S >= 0 && hsvO.S <= 0.1) && (hsvO.H >= 0 && hsvO.H <= 360) && (hsvO.V >= 0 && hsvO.V <= 0.99)) {
//        return UIColorFromRGB(0xffffff);
//    }
//    if ((hsvO.S >= 0 && hsvO.S <= 1) && (hsvO.H >= 0 && hsvO.H <= 360) && (hsvO.V >= 0 && hsvO.V <= 0.2)) {
//        return UIColorFromRGB(0xffffff);
//    }
////    UIColor * averageColor = [UIColor colorWithRed:redTotal green:greenTotal blue:blueTotal alpha:1];
//
//    return [UIColor colorWithRed:redTotal/255 green:greenTotal/255 blue:blueTotal/255 alpha:1];
//
//}

//+ (UIColor *)hsvoTranseToCorrectUIColor:(HSVObj *)hsv{
//    if ((hsv.S >= 0.1 && hsv.S <= 1) && ((hsv.H >= 0 && hsv.H <= 21) || (hsv.H >= 341 && hsv.H <= 360))&& (hsv.V >= 0.2 && hsv.V <= 0.99)) {
//        return UIColorFromRGB(0xd2314c);
//    }
//    if ((hsv.S >= 0.1 && hsv.S <= 1) && (hsv.H > 21 && hsv.H <= 41) && (hsv.V >= 0.2 && hsv.V <= 0.99)) {
//        return UIColorFromRGB(0xe27628);
//    }
//    if ((hsv.S >= 0.1 && hsv.S <= 1) && (hsv.H > 41 && hsv.H <= 63) && (hsv.V >= 0.2 && hsv.V <= 0.99)) {
//        return UIColorFromRGB(0xf1af22);
//    }
//    if ((hsv.S >= 0.1 && hsv.S <= 1) && (hsv.H >63 && hsv.H <= 161) && (hsv.V >= 0.2 && hsv.V <= 0.99)) {
//        return UIColorFromRGB(0x5fbb2d);
//    }
//    if ((hsv.S >= 0.1 && hsv.S <= 1) && (hsv.H > 161 && hsv.H <= 179) && (hsv.V >= 0.2 && hsv.V <= 0.99)) {
//        return UIColorFromRGB(0x34acb0);
//    }
//    if ((hsv.S >= 0.1 && hsv.S <= 1) && (hsv.H > 179 && hsv.H <= 251) && (hsv.V >= 0.2 && hsv.V <= 0.99)) {
//        return UIColorFromRGB(0x477bc1);
//    }
//    if ((hsv.S >= 0.1 && hsv.S <= 1) && (hsv.H > 251 && hsv.H <= 340) && (hsv.V >= 0.2 && hsv.V <= 0.99)) {
//        return UIColorFromRGB(0x9c4dff);
//    }
//    if ((hsv.S >= 0 && hsv.S <= 0.1) && (hsv.H >= 0 && hsv.H <= 360) && (hsv.V >= 0.99 && hsv.V <= 1)) {
//        return UIColorFromRGB(0x181818);
//    }
//    if ((hsv.S >= 0 && hsv.S <= 0.1) && (hsv.H >= 0 && hsv.H <= 360) && (hsv.V >= 0 && hsv.V <= 0.99)) {
//        return UIColorFromRGB(0xffffff);
//    }
//    if ((hsv.S >= 0 && hsv.S <= 1) && (hsv.H >= 0 && hsv.H <= 360) && (hsv.V >= 0 && hsv.V <= 0.2)) {
//        return UIColorFromRGB(0xffffff);
//    }
//    return nil;
//}

+ (UIColor *)signatureTextColor:(UIColor *)backgroundColor{
    if (CGColorEqualToColor(backgroundColor.CGColor, RGBCOLOR(0xff, 0xff, 0xff).CGColor)) {
        return RGBCOLOR(0x28, 0x28, 0x28);
    }
    return RGBCOLOR(0xff, 0xff, 0xff);
}
+ (UIImage *)imageForKey:(id)key{
    return [UIImage imageNamed:key];
}



+ (UIImage *)circleImage:(UIImage *)image

{
    // 开始图形上下文，NO代表透明
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    // 根据一个rect创建一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将原照片画到图形上下文
    [image drawInRect:rect];
    
    // 从上下文上获取剪裁后的照片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


@end








