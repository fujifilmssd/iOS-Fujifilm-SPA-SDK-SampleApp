//
//  QBAlbumCell.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBAlbumCell : UITableViewCell

@property (weak, nonatomic)  UIImageView *imageView1;
@property (weak, nonatomic)  UIImageView *imageView2;
@property (weak, nonatomic)  UIImageView *imageView3;
@property (weak, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic)  UILabel *countLabel;

@property (nonatomic, assign) CGFloat borderWidth;

@end
