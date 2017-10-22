//
//  QBItemCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBItemCell.h"

#import "QBVideoIndicatorView.h"
#import "QBCheckmarkView.h"

@interface QBItemCell ()

@end

@implementation QBItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        self.alpha = 1;
        self.backgroundColor = UIColor.clearColor;
        self.opaque = YES;
        self.clearsContextBeforeDrawing = YES;
        self.autoresizesSubviews = YES;
        
        // create image view, video view, overlay view
        UIImageView *uiv = [[UIImageView alloc] initWithFrame:self.frame];
        uiv.contentMode = UIViewContentModeScaleAspectFill;
        uiv.userInteractionEnabled = NO;
        uiv.translatesAutoresizingMaskIntoConstraints = NO;
        uiv.alpha = 1;
        uiv.opaque = YES;
        uiv.clearsContextBeforeDrawing = YES;
        uiv.autoresizesSubviews = YES;
        uiv.clipsToBounds = YES;
        self.imageView = uiv;
        [self addSubview:uiv];
        
        UIView *videoView = [[QBVideoIndicatorView alloc] initWithFrame:CGRectMake(0.0, 647.0, 375.0, 20.0)];
        videoView.contentMode = UIViewContentModeScaleToFill;
        videoView.userInteractionEnabled = YES;
        videoView.translatesAutoresizingMaskIntoConstraints = NO;
        videoView.backgroundColor = UIColor.clearColor;
        videoView.opaque = 1;
        videoView.hidden = YES;
        videoView.clearsContextBeforeDrawing = YES;
        videoView.autoresizesSubviews = YES;
        self.videoIndicatorView = (QBVideoIndicatorView*) videoView;
        [self addSubview:videoView];
        
        //* children of video view (video icon, slomo icon, time label)
        UIView *videoIcon = [[QBVideoIconView alloc] initWithFrame:CGRectMake(5.0, 6.0, 14.0, 8.0)];
        videoIcon.contentMode = UIViewContentModeScaleToFill;
        videoIcon.translatesAutoresizingMaskIntoConstraints = NO;
        videoIcon.userInteractionEnabled = YES;
        videoIcon.alpha = 1;
        videoIcon.backgroundColor = UIColor.clearColor;
        videoIcon.opaque = YES;
        videoIcon.clearsContextBeforeDrawing = YES;
        videoIcon.autoresizesSubviews = YES;
        self.videoIndicatorView.videoIcon = (QBVideoIconView *) videoIcon;
        [videoView addSubview:videoIcon];
        
        UIView *slomoIcon = [[QBSlomoIconView alloc] initWithFrame:CGRectMake(5.0, 3.0, 12.0, 12.0)];
        slomoIcon.contentMode = UIViewContentModeScaleToFill;
        slomoIcon.translatesAutoresizingMaskIntoConstraints = NO;
        slomoIcon.userInteractionEnabled = YES;
        slomoIcon.alpha = 1;
        slomoIcon.backgroundColor = UIColor.clearColor;
        slomoIcon.opaque = YES;
        slomoIcon.clearsContextBeforeDrawing = YES;
        slomoIcon.autoresizesSubviews = YES;
        self.videoIndicatorView.slomoIcon = (QBSlomoIconView *) slomoIcon;
        [videoView addSubview:slomoIcon];
        
        UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(23.0, 3.0, 347.0, 15.0)];
        timeLbl.text = @"00:00";
        timeLbl.textColor = UIColor.whiteColor;
        timeLbl.font = [UIFont systemFontOfSize:12.0];
        timeLbl.textAlignment = NSTextAlignmentRight;
        timeLbl.numberOfLines = 1;
        timeLbl.enabled = YES;
        timeLbl.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        timeLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        timeLbl.contentMode = UIViewContentModeLeft;
        timeLbl.alpha = 1;
        timeLbl.opaque = NO;
        timeLbl.userInteractionEnabled = NO;
        timeLbl.adjustsFontSizeToFitWidth = NO;
        timeLbl.translatesAutoresizingMaskIntoConstraints = NO;
        timeLbl.clearsContextBeforeDrawing = YES;
        timeLbl.autoresizesSubviews = YES;
        self.videoIndicatorView.timeLabel = timeLbl;
        [videoView addSubview:timeLbl];
        
        //* up a level back to overlay view
        UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 375.0, 667.0)];
        overlay.contentMode = UIViewContentModeScaleToFill;
        overlay.translatesAutoresizingMaskIntoConstraints = NO;
        overlay.userInteractionEnabled = YES;
        overlay.backgroundColor = UIColor.lightTextColor;
        overlay.opaque = YES;
        overlay.hidden = YES;
        overlay.clearsContextBeforeDrawing = YES;
        overlay.autoresizesSubviews = YES;
        self.overlayView = overlay;
        [self addSubview:overlay];
        
        //* overlay child checkmark view
        UIView *checkView = [[QBCheckmarkView alloc] initWithFrame:CGRectMake(347.0, 639.0, 24.0, 24.0)];
        checkView.contentMode = UIViewContentModeScaleToFill;
        checkView.translatesAutoresizingMaskIntoConstraints = NO;
        checkView.userInteractionEnabled = YES;
        checkView.backgroundColor = UIColor.clearColor;
        checkView.opaque = YES;
        checkView.clearsContextBeforeDrawing = YES;
        checkView.autoresizesSubviews = YES;
        [overlay addSubview:checkView];
        
        // create and assign constraints
        NSLayoutConstraint *ivTrail = [NSLayoutConstraint constraintWithItem:uiv.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:uiv attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0];
        NSLayoutConstraint *ivLead = [NSLayoutConstraint constraintWithItem:uiv attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:uiv.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0];
        NSLayoutConstraint *ivBtm = [NSLayoutConstraint constraintWithItem:uiv.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:uiv attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0];
        NSLayoutConstraint *ivTop = [NSLayoutConstraint constraintWithItem:uiv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:uiv.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0.0];
        
        
        NSLayoutConstraint *vidTrail = [NSLayoutConstraint constraintWithItem:videoView.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:videoView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0];
        NSLayoutConstraint *vidLead = [NSLayoutConstraint constraintWithItem:videoView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:videoView.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0];
        NSLayoutConstraint *vidTop = [NSLayoutConstraint constraintWithItem:videoView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:videoView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0.0];
        NSLayoutConstraint *vidHeight = [NSLayoutConstraint constraintWithItem:videoView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20.0];
        
        NSLayoutConstraint *ovTrail = [NSLayoutConstraint constraintWithItem:overlay.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0];
        NSLayoutConstraint *ovLead = [NSLayoutConstraint constraintWithItem:overlay attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:overlay.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0];
        NSLayoutConstraint *ovBtm = [NSLayoutConstraint constraintWithItem:overlay.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:overlay attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0];
        NSLayoutConstraint *ovTop = [NSLayoutConstraint constraintWithItem:overlay attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:overlay.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0.0];
        
        [self addConstraints:@[ovBtm, ovTop, ovTrail, ovLead, vidTop, vidTrail, vidLead, ivTop, ivTrail, ivBtm, ivLead]];
        
        NSLayoutConstraint *vidicHeight = [NSLayoutConstraint constraintWithItem:videoIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:8.0];
        NSLayoutConstraint *vidicWidth = [NSLayoutConstraint constraintWithItem:videoIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:14.0];
        NSLayoutConstraint *vidicLead = [NSLayoutConstraint constraintWithItem:videoIcon attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:videoIcon.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:5.0];
        NSLayoutConstraint *vidicCenterY = [NSLayoutConstraint constraintWithItem:videoIcon.superview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:videoIcon attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.0];
        
        NSLayoutConstraint *slomoHeight = [NSLayoutConstraint constraintWithItem:slomoIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:12.0];
        NSLayoutConstraint *slomoWidth = [NSLayoutConstraint constraintWithItem:slomoIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:12.0];
        NSLayoutConstraint *slomoLead = [NSLayoutConstraint constraintWithItem:slomoIcon attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:videoIcon attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0];
        NSLayoutConstraint *slomoTop = [NSLayoutConstraint constraintWithItem:slomoIcon attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:videoIcon attribute:NSLayoutAttributeTop multiplier:1 constant:-3.0];
        
        NSLayoutConstraint *timeCenterY = [NSLayoutConstraint constraintWithItem:timeLbl.superview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:timeLbl attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.0];
        NSLayoutConstraint *timeTrail = [NSLayoutConstraint constraintWithItem:timeLbl.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:timeLbl attribute:NSLayoutAttributeTrailing multiplier:1 constant:5.0];
        NSLayoutConstraint *timeLead = [NSLayoutConstraint constraintWithItem:timeLbl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:videoIcon attribute:NSLayoutAttributeTrailing multiplier:1 constant:4.0];
        
        NSLayoutConstraint *checkHeight = [NSLayoutConstraint constraintWithItem:checkView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24.0];
        NSLayoutConstraint *checkWidth = [NSLayoutConstraint constraintWithItem:checkView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:24.0];
        NSLayoutConstraint *checkRight = [NSLayoutConstraint constraintWithItem:checkView.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:checkView attribute:NSLayoutAttributeRight multiplier:1 constant:4.0];
        NSLayoutConstraint *checkBtm = [NSLayoutConstraint constraintWithItem:checkView.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:checkView attribute:NSLayoutAttributeBottom multiplier:1 constant:4.0];
        
        [videoView addConstraints:@[vidicLead, vidicCenterY, timeCenterY, timeTrail, timeLead, slomoLead, slomoTop, vidHeight]];
        [videoIcon addConstraints:@[vidicWidth, vidicHeight]];
        [slomoIcon addConstraints:@[slomoWidth, slomoHeight]];
        [overlay addConstraints:@[checkRight, checkBtm]];
        [checkView addConstraints:@[checkWidth, checkHeight]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    self.overlayView.hidden = !(selected && self.showsOverlayViewWhenSelected);
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	self.videoIndicatorView.hidden = YES;
}

@end
