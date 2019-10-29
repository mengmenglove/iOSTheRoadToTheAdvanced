//
//  HBXVIResourceLoaderManager.h
//  iOSTheRoadToTheAdvanced
//
//  Created by huangbaoxian on 2019/10/19.
//  Copyright © 2019 黄保贤. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HBXVIResourceLoaderManager : NSObject

+ (NSURL *)assetURLWithURL:(NSURL *)url;

- (AVPlayerItem *)playerItemWithURL:(NSURL *)url;



@end


