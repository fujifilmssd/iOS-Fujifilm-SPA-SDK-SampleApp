//
//  QBItemViewController.m
//  QBImagePicker
//
//  Created by Owen Hart on 1/31/16.
//  Copyright © 2016 Katsuma Tanaka. All rights reserved.
//

#import "QBItemViewController.h"

#import "QBImagePickerController.h"
#import "QBItemCell.h"
#import "QBVideoIndicatorView.h"
#import "QBCheckmarkView.h"

@interface QBItemViewController ()
@end

@implementation QBItemViewController


static NSString * const reuseIdentifier = @"QBItemCell";

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Register cell classes
	//UINib *nib = [UINib nibWithNibName:@"QBItemCell" bundle:[QBImagePickerController QBImagePickerBundle]];
    [self.collectionView registerClass:[QBItemCell class] forCellWithReuseIdentifier:reuseIdentifier];
	//[self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Configure collection view
	self.collectionView.allowsMultipleSelection = self.imagePickerController.allowsMultipleSelection;
	[self.collectionView reloadData];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	if (!self.disableScrollToBottom)
	{
		self.disableScrollToBottom = YES;

		// Scroll to bottom
		NSUInteger itemCount = [self.collectionView numberOfItemsInSection:0];
		if (itemCount > 0)
		{
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(itemCount - 1) inSection:0];
			[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
		}
	}
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	// Save indexPath for the last item
	NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
	
	// Update layout
	[self.collectionViewLayout invalidateLayout];
	
	// Restore scroll position
	[coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
	}];
}

#pragma mark <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	QBItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QBItemCell" forIndexPath:indexPath];
    
    cell.tag = indexPath.item;
	cell.showsOverlayViewWhenSelected = self.imagePickerController.allowsMultipleSelection;
	
	NSObject *item = [self objectForItemAtIndex:indexPath.item];

	UIImage *image = [self thumbnailForItem:item];
	if (image != nil) {
		cell.imageView.image = image;
	} else {
		[self loadThumbnailCell:cell withItem:item atIndexPath:indexPath];
	}
	cell.videoIndicatorView.hidden = !([self showsVideoIconForItem:item]
									   || [self showsSlowMoIconForItem:item]);
	
	if (!cell.videoIndicatorView.hidden)
	{
		NSTimeInterval duration = [self durationForItem:item];
		cell.videoIndicatorView.videoIcon.hidden = ![self showsVideoIconForItem:item];
		cell.videoIndicatorView.slomoIcon.hidden = ![self showsSlowMoIconForItem:item];
		cell.videoIndicatorView.timeLabel.hidden = (duration <= 0);
		NSInteger minutes = (NSInteger)(duration / 60.0);
		NSInteger seconds = (NSInteger)ceil(duration - 60.0 * (double)minutes);
		cell.videoIndicatorView.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
	}
	BOOL selected = [self.imagePickerController.selectedItems containsObject:item];
    
	[cell setSelected:selected];
	if (selected)
		[collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	
	return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *item = [self objectForItemAtIndex:indexPath.item];
    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:shouldDeselectItem:)])
        return [self.imagePickerController.delegate qb_imagePickerController:self.imagePickerController shouldDeselectItem:item];
    
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSObject *item = [self objectForItemAtIndex:indexPath.item];
	if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:shouldSelectItem:)])
		return [self.imagePickerController.delegate qb_imagePickerController:self.imagePickerController shouldSelectItem:item];
	
	if ([self isAutoDeselectEnabled]) {
		return YES;
	}
    
    if ([self isMaximumSelectionLimitReached]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:self.imagePickerController.maxImagesMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
	return ![self isMaximumSelectionLimitReached];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{	
	QBImagePickerController *imagePickerController = self.imagePickerController;
	NSMutableOrderedSet *selectedItems = imagePickerController.selectedItems;
	
	NSObject *item = [self objectForItemAtIndex:indexPath.item];
	if (imagePickerController.allowsMultipleSelection) {
		if ([self isAutoDeselectEnabled] && selectedItems.count > 0) {
			// Remove previous selected item from set
			[selectedItems removeObjectAtIndex:0];
			
			// Deselect previous selected item
			if (self.lastSelectedItemIndexPath) {
				[collectionView deselectItemAtIndexPath:self.lastSelectedItemIndexPath animated:NO];
			}
		}
		
		// Add item to set
		[selectedItems addObject:item];
		
		self.lastSelectedItemIndexPath = indexPath;
	}
	else
	{
		if ([imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:didFinishPickingItems:)])
			[imagePickerController.delegate qb_imagePickerController:imagePickerController didFinishPickingItems:@[item]];
	}
	
	if ([imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:didSelectItem:)])
		[imagePickerController.delegate qb_imagePickerController:imagePickerController didSelectItem:item];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (!self.imagePickerController.allowsMultipleSelection)
		return;
	
	QBImagePickerController *imagePickerController = self.imagePickerController;
	NSMutableOrderedSet *selectedItems = imagePickerController.selectedItems;
	
	NSObject *item = [self objectForItemAtIndex:indexPath.item];
	
	// Remove asset from set
	[selectedItems removeObject:item];
	
	self.lastSelectedItemIndexPath = nil;

	if ([imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:didDeselectItem:)]) {
		[imagePickerController.delegate qb_imagePickerController:imagePickerController didDeselectItem:item];
	}
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger numberOfColumns;
	if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
		numberOfColumns = self.imagePickerController.numberOfColumnsInPortrait;
	} else {
		numberOfColumns = self.imagePickerController.numberOfColumnsInLandscape;
	}
	
	CGFloat width = (CGRectGetWidth(self.view.frame) - 2.0 * (numberOfColumns - 1)) / numberOfColumns;
    
	return CGSizeMake(width, width);
}

#pragma mark - Selection Config

- (BOOL)isAutoDeselectEnabled
{
	return (self.imagePickerController.maximumNumberOfSelection == 1
			&& self.imagePickerController.maximumNumberOfSelection >= self.imagePickerController.minimumNumberOfSelection);
}

- (BOOL)isMinimumSelectionLimitFulfilled
{
	return (self.imagePickerController.minimumNumberOfSelection <= self.imagePickerController.selectedItems.count);
}

- (BOOL)isMaximumSelectionLimitReached
{
	NSUInteger minimumNumberOfSelection = MAX(1, self.imagePickerController.minimumNumberOfSelection);
	
	if (minimumNumberOfSelection <= self.imagePickerController.maximumNumberOfSelection) {
		return (self.imagePickerController.maximumNumberOfSelection <= self.imagePickerController.selectedItems.count);
	}
	
	return NO;
}

#pragma mark - Data Config

- (NSObject *)objectForItemAtIndex:(NSUInteger)index { return nil; }
- (UIImage *)thumbnailForItem:(NSObject *)item { return nil; }
- (void)loadThumbnailCell:(QBItemCell *)cell withItem:(NSObject *)item atIndexPath:(NSIndexPath *)indexPath { }
- (BOOL)showsVideoIconForItem:(NSObject *)item { return NO; }
- (BOOL)showsSlowMoIconForItem:(NSObject *)item { return NO; }
- (NSTimeInterval)durationForItem:(NSObject *)item { return 0; }
- (NSUInteger)numberOfImages { return 0; }
- (NSUInteger)numberOfVideos { return 0; }

@end
