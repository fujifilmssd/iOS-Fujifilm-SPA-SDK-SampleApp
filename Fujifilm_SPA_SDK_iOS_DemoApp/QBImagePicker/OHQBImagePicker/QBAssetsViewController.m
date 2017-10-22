//
//  QBAssetsViewController.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsViewController.h"
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

// Views
#import "QBImagePickerController.h"
#import "QBItemCell.h"

static NSString * const brokenImageBase64 = @"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";

static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

@implementation NSIndexSet (Convenience)

- (NSArray *)qb_indexPathsFromIndexesWithSection:(NSUInteger)section
{
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}

@end

@implementation UICollectionView (Convenience)

- (NSArray *)qb_indexPathsForElementsInRect:(CGRect)rect
{
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

@end

@interface QBAssetsViewController () <PHPhotoLibraryChangeObserver>

//@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *doneBarButton;

@property (nonatomic, strong) PHFetchResult *fetchResult;

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, assign) CGRect previousPreheatRect;

@end

@implementation QBAssetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpToolbarItems];
    [self resetCachedAssets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure navigation item
    self.navigationItem.title = self.assetCollection.localizedTitle;
    self.navigationItem.prompt = self.imagePickerController.prompt;
    self.doneBarButton = [self.navigationItem rightBarButtonItem];
    
    // Show/hide 'Done' button
    if (self.imagePickerController.allowsMultipleSelection) {
        [self.navigationItem setRightBarButtonItem:self.doneBarButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
    
    [self updateDoneButtonState];
    [self updateSelectionInfo];
    if (self.imagePickerController.selectedItems.count > 0 && self.navigationController.toolbar.isHidden) {
        // Show toolbar
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
	
	// Register observer
	[[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
	// Deregister observer
	[[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

	[self updateCachedAssets];
}

#pragma mark - Accessors

- (void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    
    [self updateFetchRequest];
    [self.collectionView reloadData];
}

- (PHCachingImageManager *)imageManager
{
    if (_imageManager == nil) {
        _imageManager = [PHCachingImageManager new];
    }
    
    return _imageManager;
}

#pragma mark - Actions

//- (IBAction)done:(id)sender
//{
//    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:didFinishPickingItems:)]) {
//        [self.imagePickerController.delegate qb_imagePickerController:self.imagePickerController
//                                               didFinishPickingItems:self.imagePickerController.selectedItems.array];
//    }
//}
- (void)doneTapped:(id)sender
{
    [self.imagePickerController dismissPicker];
    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:didFinishPickingItems:)]) {
        [self.imagePickerController.delegate qb_imagePickerController:self.imagePickerController                                            didFinishPickingItems:self.imagePickerController.selectedItems.array];
    }
}

- (void)cancelTapped:(id)sender
{
    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerControllerDidCancel:)]) {
        [self.imagePickerController.delegate qb_imagePickerControllerDidCancel:self.imagePickerController];
    }
}


#pragma mark - Toolbar

- (void)setUpToolbarItems
{
    // Space
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    // Info label
    NSDictionary *attributes = @{ NSForegroundColorAttributeName: [UIColor blackColor] };
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    infoButtonItem.enabled = NO;
    [infoButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [infoButtonItem setTitleTextAttributes:attributes forState:UIControlStateDisabled];
    
    self.toolbarItems = @[leftSpace, infoButtonItem, rightSpace];
}

- (void)updateSelectionInfo
{
    NSMutableOrderedSet *selectedItems = self.imagePickerController.selectedItems;
    
    if (selectedItems.count > 0) {
        NSString *format;
        if (selectedItems.count > 1) {
            format = @"%ld Items Selected";
        } else {
            format = @"%ld Item Selected";
        }
        
        NSString *title = [NSString stringWithFormat:format, selectedItems.count];
        [(UIBarButtonItem *)self.toolbarItems[1] setTitle:title];
    } else {
        [(UIBarButtonItem *)self.toolbarItems[1] setTitle:@""];
    }
}


#pragma mark - Fetching Assets

- (void)updateFetchRequest
{
    if (self.assetCollection) {
        PHFetchOptions *options = [PHFetchOptions new];
        NSPredicate *mediaTypePredicate;
        switch (self.imagePickerController.mediaType) {
            case QBImagePickerMediaTypeImage:
                mediaTypePredicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                break;
                
            case QBImagePickerMediaTypeVideo:
                mediaTypePredicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
                break;
                
            default:
                break;
        }
        
        NSPredicate *mediaSubTypePredicate;
        if (self.imagePickerController.assetMediaSubtypes)
        {
            mediaSubTypePredicate = [NSPredicate predicateWithFormat:@"mediaSubtype in %@ ", self.imagePickerController.assetMediaSubtypes];
        }
        NSMutableArray *predicates = [@[] mutableCopy];
        if (mediaTypePredicate)
        {
            [predicates addObject:mediaTypePredicate];
        }
        if (mediaSubTypePredicate)
        {
            [predicates addObject:mediaSubTypePredicate];
        }
        if (predicates.count > 0)
        {
            options.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        }
        
        self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options];
        
        if ([self isAutoDeselectEnabled] && self.imagePickerController.selectedItems.count > 0) {
            // Get index of previous selected asset
            PHAsset *asset = [self.imagePickerController.selectedItems firstObject];
            NSInteger assetIndex = [self.fetchResult indexOfObject:asset];
            self.lastSelectedItemIndexPath = [NSIndexPath indexPathForItem:assetIndex inSection:0];
        }
    } else {
        self.fetchResult = nil;
    }
}


#pragma mark - Checking for Selection Limit

- (void)updateDoneButtonState
{
    self.doneBarButton.enabled = [self isMinimumSelectionLimitFulfilled];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets
{
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets
{
    BOOL isViewVisible = [self isViewLoaded] && self.view.window != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0, -0.5 * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0) {
        // Compute the assets to start caching and to stop caching
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView qb_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        } removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView qb_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        CGSize itemSize = [(UICollectionViewFlowLayout *)self.collectionViewLayout itemSize];
        CGSize targetSize = CGSizeScale(itemSize, [[UIScreen mainScreen] scale]);
        
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:targetSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:targetSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect addedHandler:(void (^)(CGRect addedRect))addedHandler removedHandler:(void (^)(CGRect removedRect))removedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item < self.fetchResult.count) {
            PHAsset *asset = self.fetchResult[indexPath.item];
            [assets addObject:asset];
        }
    }
    return assets;
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.fetchResult];
        
        if (collectionChanges) {
            // Get the new fetch result
            self.fetchResult = [collectionChanges fetchResultAfterChanges];
            
            if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
                // We need to reload all if the incremental diffs are not available
                [self.collectionView reloadData];
            } else {
                // If we have incremental diffs, tell the collection view to animate insertions and deletions
                [self.collectionView performBatchUpdates:^{
                    NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                    if ([removedIndexes count]) {
                        [self.collectionView deleteItemsAtIndexPaths:[removedIndexes qb_indexPathsFromIndexesWithSection:0]];
                    }
                    
                    NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                    if ([insertedIndexes count]) {
                        [self.collectionView insertItemsAtIndexPaths:[insertedIndexes qb_indexPathsFromIndexesWithSection:0]];
                    }
                    
                    NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                    if ([changedIndexes count]) {
                        [self.collectionView reloadItemsAtIndexPaths:[changedIndexes qb_indexPathsFromIndexesWithSection:0]];
                    }
                } completion:NULL];
            }
            
            [self resetCachedAssets];
        }
    });
}

#pragma mark - QBItemViewController

- (NSObject *)objectForItemAtIndex:(NSUInteger)index
{
	return self.fetchResult[index];
}

- (UIImage *)thumbnailForItem:(NSObject *)item
{
	return nil;
}

- (void)loadThumbnailCell:(QBItemCell *)cell withItem:(NSObject *)item atIndexPath:(NSIndexPath *)indexPath
{
	PHAsset *asset = (PHAsset *)item;
	CGSize itemSize = [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout itemSize];
	CGSize targetSize = CGSizeScale(itemSize, [[UIScreen mainScreen] scale]);
	
	[self.imageManager requestImageForAsset:asset
								 targetSize:targetSize
								contentMode:PHImageContentModeAspectFill
									options:nil
							  resultHandler:^(UIImage *result, NSDictionary *info) {
								  if (cell.tag == indexPath.row) {
									  cell.imageView.image = result;
                                      if (result == nil) {
                                          cell.imageView.image = [QBAssetsViewController getBrokenImage];
                                          [cell setUserInteractionEnabled:NO];
                                      }
                                      else if (!cell.userInteractionEnabled) {
                                          [cell setUserInteractionEnabled:YES];
                                      }
								  }
							  }];
}

- (BOOL)showsVideoIconForItem:(NSObject *)item
{
	PHAsset *asset = (PHAsset *)item;
	return (asset.mediaType == PHAssetMediaTypeVideo)
	&& !(asset.mediaSubtypes & PHAssetMediaSubtypeVideoHighFrameRate);
}

- (BOOL)showsSlowMoIconForItem:(NSObject *)item
{
	PHAsset *asset = (PHAsset *)item;
	return (asset.mediaType == PHAssetMediaTypeVideo)
	&& (asset.mediaSubtypes & PHAssetMediaSubtypeVideoHighFrameRate);
}

- (NSTimeInterval)durationForItem:(NSObject *)item
{
	PHAsset *asset = (PHAsset *)item;
	return asset.duration;
}

- (NSUInteger)numberOfImages
{
	return [self.fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
}

- (NSUInteger)numberOfVideos
{
	return [self.fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeVideo];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self updateCachedAssets];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.fetchResult.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                  withReuseIdentifier:@"FooterView"
                                                                                         forIndexPath:indexPath];
        
        footerView.contentMode = UIViewContentModeCenter;
        footerView.userInteractionEnabled = YES;
        footerView.multipleTouchEnabled = YES;
        footerView.clearsContextBeforeDrawing = YES;
        footerView.clipsToBounds = YES;
        footerView.autoresizesSubviews = YES;
        footerView.tag = 0;
        
        // Number of assets
        UILabel *label = [footerView viewWithTag:2];
        
        if (label == nil)
        {
            UILabel *photosCountLbl = [[UILabel alloc] init];
            photosCountLbl.text = @"Number of Photos and Videos";
            photosCountLbl.textColor = UIColor.blackColor;
            photosCountLbl.font = [UIFont systemFontOfSize:17.0];
            photosCountLbl.textAlignment = NSTextAlignmentCenter;
            photosCountLbl.enabled = YES;
            photosCountLbl.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
            photosCountLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            photosCountLbl.contentMode = UIViewContentModeLeft;
            photosCountLbl.tag = 2;
            photosCountLbl.frame = CGRectMake(0.0, 22.0, 375.0, 21.0);
            photosCountLbl.clearsContextBeforeDrawing = YES;
            photosCountLbl.autoresizesSubviews = YES;
            [footerView addSubview:photosCountLbl];
            
            NSLayoutConstraint *alignY = [NSLayoutConstraint constraintWithItem:photosCountLbl.superview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:photosCountLbl attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
            NSLayoutConstraint *rightSpace = [NSLayoutConstraint constraintWithItem:photosCountLbl.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:photosCountLbl attribute:NSLayoutAttributeRight multiplier:1 constant:0.0];
            NSLayoutConstraint *leftSpace = [NSLayoutConstraint constraintWithItem:photosCountLbl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:photosCountLbl.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0];
            
            [footerView addConstraints:@[alignY, rightSpace, leftSpace]];
            label = photosCountLbl;
        }
        
        // update assets label
		NSUInteger numberOfPhotos = [self numberOfImages];
		NSUInteger numberOfVideos = [self numberOfVideos];
		
        switch (self.imagePickerController.mediaType) {
            case QBImagePickerMediaTypeAny:
            {
                NSString *format;
                if (numberOfPhotos == 1) {
                    if (numberOfVideos == 1) {
                        format = @"%ld Photo, %ld Video";
                    } else {
                        format = @"%ld Photo, %ld Videos";
                    }
                } else if (numberOfVideos == 1) {
                    format = @"%ld Photos, %ld Video";
                } else {
                    format = @"%ld Photos, %ld Videos";
                }
                
                label.text = [NSString stringWithFormat:format, numberOfPhotos, numberOfVideos];
            }
                break;
                
            case QBImagePickerMediaTypeImage:
            {
                NSString *format = (numberOfPhotos == 1) ? @"%ld Photo" : @"%ld Photos";
                
                label.text = [NSString stringWithFormat:format, numberOfPhotos];
            }
                break;
                
            case QBImagePickerMediaTypeVideo:
            {
                NSString *format = (numberOfVideos == 1) ? @"%ld Video" : @"%ld Videos";
                
                label.text = [NSString stringWithFormat:format, numberOfVideos];
            }
                break;
                
        }
        
        return footerView;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
	
	if (self.imagePickerController.allowsMultipleSelection)
	{
		[self updateDoneButtonState];
		
		if (self.imagePickerController.showsNumberOfSelectedItems) {
			[self updateSelectionInfo];
			
			if (self.navigationController.toolbar.isHidden && self.imagePickerController.selectedItems.count > 0) {
				// Show toolbar
				[self.navigationController setToolbarHidden:NO animated:YES];
			}
		}
	}
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[super collectionView:collectionView didDeselectItemAtIndexPath:indexPath];

    if (!self.imagePickerController.allowsMultipleSelection)
        return;
    
    [self updateDoneButtonState];
    
    if (self.imagePickerController.showsNumberOfSelectedItems) {
        [self updateSelectionInfo];
        
        if (self.imagePickerController.selectedItems.count == 0) {
            // Hide toolbar
            [self.navigationController setToolbarHidden:YES animated:YES];
        }
    }
}

+(UIImage *) getBrokenImage {
    return [self getImageFromBase64:brokenImageBase64];
}
+(UIImage *)getImageFromBase64:(NSString *)base64 {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
