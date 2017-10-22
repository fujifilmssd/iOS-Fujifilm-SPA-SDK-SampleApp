//
//  QBImagePickerController.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class QBImagePickerController;

@protocol QBImagePickerControllerDelegate <NSObject>

@optional
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingItems:(NSArray *)items;
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController;

- (BOOL)qb_imagePickerController:(QBImagePickerController *)imagePickerController shouldSelectItem:(NSObject *)item;
- (BOOL)qb_imagePickerController:(QBImagePickerController *)imagePickerController shouldDeselectItem:(NSObject *)item;
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectItem:(NSObject *)item;
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didDeselectItem:(NSObject *)item;
@end

typedef NS_ENUM(NSUInteger, QBImagePickerMediaType) {
    QBImagePickerMediaTypeAny = 0,
    QBImagePickerMediaTypeImage,
    QBImagePickerMediaTypeVideo,
};

@interface QBImagePickerController : UIViewController

@property (nonatomic, strong) NSBundle *assetBundle;

@property (nonatomic, weak) id<QBImagePickerControllerDelegate> delegate;

@property (nonatomic, strong, readonly) NSMutableOrderedSet *selectedItems;
@property (nonatomic, strong) UICollectionViewController *assetsVC;

@property (nonatomic, copy) NSArray *assetCollectionSubtypes;
@property (nonatomic, copy) NSArray *assetMediaSubtypes;
@property (nonatomic, assign) BOOL excludeEmptyAlbums;
@property (nonatomic, assign) BOOL includeRecentlyDeletedAlbum;
@property (nonatomic, assign) QBImagePickerMediaType mediaType;

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

@property (nonatomic, copy) NSString *prompt;
@property (nonatomic, assign) BOOL showsNumberOfSelectedItems;

@property (nonatomic, assign) NSUInteger numberOfColumnsInPortrait;
@property (nonatomic, assign) NSUInteger numberOfColumnsInLandscape;

@property (nonatomic, copy) NSString *maxImagesMessage;

+ (NSBundle *)QBImagePickerBundle;
- (void)segueToView;
- (void)setSelectedItemsWithIDs:(NSArray<NSString *>*)ids;
- (UINavigationController *)createPickerNavigation;
- (void) dismissPicker;
@end
