//
//  QBItemCell.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QBVideoIndicatorView;

@interface QBItemCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) QBVideoIndicatorView *videoIndicatorView;
@property (weak, nonatomic) UIView *overlayView;

@property (nonatomic, assign) BOOL showsOverlayViewWhenSelected;

@end
