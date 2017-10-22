//
//  QBVideoIndicatorView.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/04.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBVideoIndicatorView.h"

@interface QBVideoIndicatorView ()
{
	CAGradientLayer *gradientLayer;
}
@end

@implementation QBVideoIndicatorView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil)
	{
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self != nil)
	{
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	// Add gradient layer
	gradientLayer = [CAGradientLayer layer];
	
	gradientLayer.colors = @[
							 (__bridge id)[[UIColor clearColor] CGColor],
							 (__bridge id)[[UIColor blackColor] CGColor]
							 ];
	
	[self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	gradientLayer.frame = self.bounds;
}

@end
