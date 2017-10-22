//
//  QBAssetsViewController.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QBItemViewController.h"

@class PHAssetCollection;

@interface QBAssetsViewController : QBItemViewController

@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
