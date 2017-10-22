//
//  QBAlbumCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAlbumCell.h"

@implementation QBAlbumCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.editingAccessoryType = UITableViewCellAccessoryNone;
        if (@available(iOS 9.0, *)) {
            self.focusStyle = UITableViewCellFocusStyleDefault;
        }
        self.shouldIndentWhileEditing = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        self.alpha = 1.0;
        self.opaque = YES;
        self.clearsContextBeforeDrawing = YES;
        self.autoresizesSubviews = YES;
        
        
        // add view to content view
        UIView *contentView = self.contentView;
        UIView *qbView = [[UIView alloc] init];
        qbView.userInteractionEnabled = YES;
        qbView.opaque = YES;
        qbView.backgroundColor = UIColor.whiteColor;
        qbView.clearsContextBeforeDrawing = YES;
        qbView.autoresizesSubviews = YES;
        qbView.contentMode = UIViewContentModeScaleToFill;
        qbView.frame = CGRectMake(16.0, 7.0, 68.0, 72.0);
        [contentView addSubview:qbView];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:qbView.superview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:qbView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:qbView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:qbView.superview attribute:NSLayoutAttributeLeftMargin multiplier:1 constant:0.0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:qbView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:72.0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:qbView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:68.0];
        
        // add title label
        UILabel *title = [[UILabel alloc] init];
        title.enabled = YES;
        title.userInteractionEnabled = YES;
        title.text = @"Album Title";
        title.font = [UIFont systemFontOfSize:17.0];
        title.textColor = UIColor.blackColor;
        title.textAlignment = NSTextAlignmentLeft;
        title.numberOfLines = 1;
        title.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        title.lineBreakMode = NSLineBreakByTruncatingTail;
        title.minimumScaleFactor = 9.0/title.font.pointSize;
        title.contentMode = UIViewContentModeLeft;
        title.clearsContextBeforeDrawing = YES;
        title.autoresizesSubviews = YES;
        title.frame = CGRectMake(102.0, 22.0, 232.0, 21.0);
        
        [contentView addSubview:title];
        
        // add count label
        UILabel *count = [[UILabel alloc] init];
        count.enabled = YES;
        count.userInteractionEnabled = YES;
        count.text = @"Number of Photos";
        count.font = [UIFont systemFontOfSize:12.0];
        count.textColor = UIColor.blackColor;
        count.textAlignment = NSTextAlignmentLeft;
        count.numberOfLines = 1;
        count.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        count.lineBreakMode = NSLineBreakByTruncatingTail;
        count.adjustsFontSizeToFitWidth = NO;
        count.contentMode = UIViewContentModeLeft;
        count.alpha = 1.0;
        count.clearsContextBeforeDrawing = YES;
        count.autoresizesSubviews = YES;
        count.frame = CGRectMake(102.0, 46.0, 232.0, 15.0);
        
        [contentView addSubview:count];
        
        // add label constraints
        NSLayoutConstraint *titleLeft = [NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:qbView attribute:NSLayoutAttributeRight multiplier:1.0 constant:18.0];
        NSLayoutConstraint *countLeft = [NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:count attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0];
        NSLayoutConstraint *countRight = [NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:count attribute:NSLayoutAttributeRight multiplier:1 constant:0.0];
        NSLayoutConstraint *titleTop = [NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:title.superview attribute:NSLayoutAttributeTopMargin multiplier:1 constant:14.0];
        NSLayoutConstraint *titleRight = [NSLayoutConstraint constraintWithItem:title.superview attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:title attribute:NSLayoutAttributeRight multiplier:1 constant:0.0];
        NSLayoutConstraint *countTop = [NSLayoutConstraint constraintWithItem:count attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:title attribute:NSLayoutAttributeBottom multiplier:1 constant:3.0];
        
        [contentView addConstraints:@[titleTop, titleRight, titleLeft, countLeft, countRight, countTop, centerY, left]];
        
        // add 3 image views
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 4.0, 68.0, 68.0)];
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 2.0, 64.0, 64.0)];
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 4.0, 60.0, 60.0)];
        self.imageView1 = imageView1;
        self.imageView2 = imageView2;
        self.imageView3 = imageView3;
        self.titleLabel = title;
        self.countLabel = count;
        
        imageView1.userInteractionEnabled = NO;
        imageView1.contentMode = UIViewContentModeScaleAspectFill;
        imageView1.alpha = 1.0;
        imageView1.opaque = YES;
        imageView1.clearsContextBeforeDrawing = YES;
        imageView1.clipsToBounds = YES;
        imageView1.autoresizesSubviews = YES;
        [imageView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        imageView2.userInteractionEnabled = NO;
        imageView2.contentMode = UIViewContentModeScaleAspectFill;
        imageView2.alpha = 1.0;
        imageView2.opaque = YES;
        imageView2.clearsContextBeforeDrawing = YES;
        imageView2.clipsToBounds = YES;
        imageView2.autoresizesSubviews = YES;
        [imageView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        imageView3.userInteractionEnabled = NO;
        imageView3.contentMode = UIViewContentModeScaleAspectFill;
        imageView3.alpha = 1.0;
        imageView3.opaque = YES;
        imageView3.clearsContextBeforeDrawing = YES;
        imageView3.clipsToBounds = YES;
        imageView3.autoresizesSubviews = YES;
        [imageView3 setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [qbView addSubview:imageView3];
        [qbView addSubview:imageView2];
        [qbView addSubview:imageView1];
        
        // add constraints for image views
        NSLayoutConstraint *iv2Top = [NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView2.superview attribute:NSLayoutAttributeTop multiplier:1 constant:2.0];
        NSLayoutConstraint *iv2CenterX = [NSLayoutConstraint constraintWithItem:imageView2.superview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView2 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0];
        NSLayoutConstraint *iv1CenterX = [NSLayoutConstraint constraintWithItem:imageView1.superview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView1 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0];
        NSLayoutConstraint *iv1Btm = [NSLayoutConstraint constraintWithItem:imageView1.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:imageView1 attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0];
        NSLayoutConstraint *iv3CenterX = [NSLayoutConstraint constraintWithItem:imageView3.superview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView3 attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0];
        NSLayoutConstraint *iv3Top = [NSLayoutConstraint constraintWithItem:imageView3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView3.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0.0];
        NSLayoutConstraint *iv1Height = [NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:68.0];
        NSLayoutConstraint *iv1Width = [NSLayoutConstraint constraintWithItem:imageView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:68.0];
        NSLayoutConstraint *iv2Height = [NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64.0];
        NSLayoutConstraint *iv2Width = [NSLayoutConstraint constraintWithItem:imageView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64.0];
        NSLayoutConstraint *iv3Height = [NSLayoutConstraint constraintWithItem:imageView3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60.0];
        NSLayoutConstraint *iv3Width = [NSLayoutConstraint constraintWithItem:imageView3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60.0];
        
        [qbView addConstraints:@[iv1CenterX, iv1Btm, iv2Top, iv2CenterX, iv3CenterX, iv3Top, height, width]];
        [imageView1 addConstraints:@[iv1Width, iv1Height]];
        [imageView2 addConstraints:@[iv2Width, iv2Height]];
        [imageView3 addConstraints:@[iv3Width, iv3Height]];
    }
    return self;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    
    self.imageView1.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView1.layer.borderWidth = borderWidth;
    
    self.imageView2.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView2.layer.borderWidth = borderWidth;
    
    self.imageView3.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView3.layer.borderWidth = borderWidth;
}

@end
