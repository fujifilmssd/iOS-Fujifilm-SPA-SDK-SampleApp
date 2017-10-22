//
//  QBItemViewController.h
//  QBImagePicker
//
//  Created by Owen Hart on 1/31/16.
//  Copyright © 2016 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QBImagePickerController;
@class QBItemCell;
@interface QBItemViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL disableScrollToBottom;
@property (nonatomic, weak) QBImagePickerController *imagePickerController;
@property (nonatomic, strong) NSIndexPath *lastSelectedItemIndexPath;

- (BOOL)isAutoDeselectEnabled;
- (BOOL)isMinimumSelectionLimitFulfilled;
- (BOOL)isMaximumSelectionLimitReached;

- (NSObject *)objectForItemAtIndex:(NSUInteger)index;
- (UIImage *)thumbnailForItem:(NSObject *)item;
- (void)loadThumbnailCell:(QBItemCell *)cell withItem:(NSObject *)item atIndexPath:(NSIndexPath *)indexPath;
- (BOOL)showsVideoIconForItem:(NSObject *)item;
- (BOOL)showsSlowMoIconForItem:(NSObject *)item;
- (NSTimeInterval)durationForItem:(NSObject *)item;
- (NSUInteger)numberOfImages;
- (NSUInteger)numberOfVideos;

@end
