//
//  QBAlbumsViewController.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAlbumsViewController.h"
#import <Photos/Photos.h>

// Views
#import "QBAlbumCell.h"

// ViewControllers
#import "QBImagePickerController.h"
#import "QBAssetsViewController.h"

NSInteger const QBPHAssetCollectionSubtypeRecentlyDeleted = 1000000201;
NSString * const COLLECTION_TITLE_RECENTLY_DELETED = @"Recently Deleted";

static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

@interface QBAlbumsViewController () <PHPhotoLibraryChangeObserver>

//@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *doneBarButton;

@property (nonatomic, copy) NSArray *fetchResults;
@property (nonatomic, copy) NSArray *assetCollections;

@end

@implementation QBAlbumsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpToolbarItems];
    
    // Fetch user albums and smart albums
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    self.fetchResults = @[smartAlbums, userAlbums];
    
    [self updateAssetCollections];
    
    // Register observer
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure navigation item
    self.navigationItem.title = @"Photos";
    self.navigationItem.prompt = self.imagePickerController.prompt;
    self.doneBarButton = [self.navigationItem rightBarButtonItem];
    
    // Show/hide 'Done' button
    if (self.imagePickerController.allowsMultipleSelection) {
        [self.navigationItem setRightBarButtonItem:self.doneBarButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
    
    [self updateControlState];
    [self updateSelectionInfo];
    if (self.imagePickerController.selectedItems.count > 0 && self.navigationController.toolbar.isHidden) {
        // Show toolbar
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)dealloc
{
    // Deregister observer
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    QBAssetsViewController *assetsViewController = segue.destinationViewController;
//    assetsViewController.imagePickerController = self.imagePickerController;
//
//    PHAssetCollection *collection = self.assetCollections[self.tableView.indexPathForSelectedRow.row];
//
//    if (collection.assetCollectionSubtype == QBPHAssetCollectionSubtypeRecentlyDeleted ||
//        [collection.localizedTitle isEqualToString:COLLECTION_TITLE_RECENTLY_DELETED])
//        assetsViewController.disableScrollToBottom = YES;
//
//    assetsViewController.assetCollection = self.assetCollections[self.tableView.indexPathForSelectedRow.row];
}


#pragma mark - Actions

//- (IBAction)cancel:(id)sender
//{
//    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerControllerDidCancel:)]) {
//        [self.imagePickerController.delegate qb_imagePickerControllerDidCancel:self.imagePickerController];
//    }
//}
//
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
     [self.imagePickerController dismissPicker];
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


#pragma mark - Fetching Asset Collections

- (void)updateAssetCollections
{
    // Filter albums
    NSArray *assetCollectionSubtypes = self.imagePickerController.assetCollectionSubtypes;
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            
            if (subtype == PHAssetCollectionSubtypeAlbumRegular) {
                [userAlbums addObject:assetCollection];
            } else if ([assetCollectionSubtypes containsObject:@(subtype)]) {
                if (!smartAlbums[@(subtype)]) {
                    smartAlbums[@(subtype)] = [NSMutableArray array];
                }
                [smartAlbums[@(subtype)] addObject:assetCollection];
            }
        }];
    }
	
    NSMutableArray *assetCollections = [NSMutableArray array];

    // Fetch "Recently Deleted" album
    if (self.imagePickerController.includeRecentlyDeletedAlbum)
    {
        __block PHAssetCollection *recentlyDeletedCollection = nil;
        PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                              subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            if ([assetCollection.localizedTitle isEqualToString:COLLECTION_TITLE_RECENTLY_DELETED])
                recentlyDeletedCollection = assetCollection;
        }];

        if (recentlyDeletedCollection == nil)
        {
            fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                   subtype:QBPHAssetCollectionSubtypeRecentlyDeleted options:nil];
            if (fetchResult.count == 1
                && [fetchResult.firstObject isKindOfClass:PHAssetCollection.class]
                && ((PHAssetCollection *)fetchResult.firstObject).assetCollectionSubtype == QBPHAssetCollectionSubtypeRecentlyDeleted)
            {
                recentlyDeletedCollection = (PHAssetCollection *)fetchResult.firstObject;
            }
        }

        if (recentlyDeletedCollection != nil)
            [assetCollections addObject:recentlyDeletedCollection];
    }

    // Fetch smart albums
    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
        NSArray *collections = smartAlbums[assetCollectionSubtype];
        
        if (collections) {
            [assetCollections addObjectsFromArray:collections];
        }
    }
    
    // Fetch user albums
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        [assetCollections addObject:assetCollection];
    }];

    self.assetCollections = [assetCollections filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PHAssetCollection * _Nonnull assetCollection, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        if (!self.imagePickerController.excludeEmptyAlbums)
        {
            return YES;
        }
        
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
            NSCompoundPredicate *preidcate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
            options.predicate = preidcate;
        }
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        return fetchResult.count > 0;
    }]];
}

- (UIImage *)placeholderImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *backgroundColor = [UIColor colorWithRed:(239.0 / 255.0) green:(239.0 / 255.0) blue:(244.0 / 255.0) alpha:1.0];
    UIColor *iconColor = [UIColor colorWithRed:(179.0 / 255.0) green:(179.0 / 255.0) blue:(182.0 / 255.0) alpha:1.0];
    
    // Background
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // Icon (back)
    CGRect backIconRect = CGRectMake(size.width * (16.0 / 68.0),
                                     size.height * (20.0 / 68.0),
                                     size.width * (32.0 / 68.0),
                                     size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, backIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(backIconRect, 1.0, 1.0));
    
    // Icon (front)
    CGRect frontIconRect = CGRectMake(size.width * (20.0 / 68.0),
                                      size.height * (24.0 / 68.0),
                                      size.width * (32.0 / 68.0),
                                      size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, -1.0, -1.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, frontIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, 1.0, 1.0));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - Checking for Selection Limit

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

- (void)updateControlState
{
    self.doneBarButton.enabled = [self isMinimumSelectionLimitFulfilled];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetCollections.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QBAssetsViewController *assetsViewController = self.imagePickerController.assetsVC;
    assetsViewController.imagePickerController = self.imagePickerController;
    
    PHAssetCollection *collection = self.assetCollections[self.tableView.indexPathForSelectedRow.row];
    
    if (collection.assetCollectionSubtype == QBPHAssetCollectionSubtypeRecentlyDeleted ||
        [collection.localizedTitle isEqualToString:COLLECTION_TITLE_RECENTLY_DELETED])
        assetsViewController.disableScrollToBottom = YES;
    
    assetsViewController.assetCollection = self.assetCollections[self.tableView.indexPathForSelectedRow.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.imagePickerController segueToView];
    //[self performSegueWithIdentifier:self.transition.identifier sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    cell.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
    
    // Thumbnail
    PHAssetCollection *assetCollection = self.assetCollections[indexPath.row];
    
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
    
    NSPredicate *mediaSubTtypePredicate;
    if (self.imagePickerController.assetMediaSubtypes)
    {
        mediaSubTtypePredicate = [NSPredicate predicateWithFormat:@"mediaSubtype in %@ ", self.imagePickerController.assetMediaSubtypes];
    }
    NSMutableArray *predicates = [@[] mutableCopy];
    if (mediaTypePredicate)
    {
        [predicates addObject:mediaTypePredicate];
    }
    if (mediaSubTtypePredicate)
    {
        [predicates addObject:mediaSubTtypePredicate];
    }
    if (predicates.count > 0)
    {
        NSCompoundPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        options.predicate = predicate;
    }

    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    if (fetchResult.count >= 3) {
        cell.imageView3.hidden = NO;
        
        [imageManager requestImageForAsset:fetchResult[fetchResult.count - 3]
                                targetSize:CGSizeScale(cell.imageView3.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView3.image = result;
                                 }
                             }];
    } else {
        cell.imageView3.hidden = YES;
    }
    
    if (fetchResult.count >= 2) {
        cell.imageView2.hidden = NO;
        
        [imageManager requestImageForAsset:fetchResult[fetchResult.count - 2]
                                targetSize:CGSizeScale(cell.imageView2.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView2.image = result;
                                 }
                             }];
    } else {
        cell.imageView2.hidden = YES;
    }
    
    if (fetchResult.count >= 1) {
        [imageManager requestImageForAsset:fetchResult[fetchResult.count - 1]
                                targetSize:CGSizeScale(cell.imageView1.frame.size, [[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.imageView1.image = result;
                                 }
                             }];
    }
    
    if (fetchResult.count == 0) {
        cell.imageView3.hidden = NO;
        cell.imageView2.hidden = NO;
        
        // Set placeholder image
        UIImage *placeholderImage = [self placeholderImageWithSize:cell.imageView1.frame.size];
        cell.imageView1.image = placeholderImage;
        cell.imageView2.image = placeholderImage;
        cell.imageView3.image = placeholderImage;
    }
    
    // Album title
    cell.titleLabel.text = assetCollection.localizedTitle;
    
    // Number of photos
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (long)fetchResult.count];
    
    return cell;
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update fetch results
        NSMutableArray *fetchResults = [self.fetchResults mutableCopy];
        
        [self.fetchResults enumerateObjectsUsingBlock:^(PHFetchResult *fetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:fetchResult];
            
            if (changeDetails) {
                [fetchResults replaceObjectAtIndex:index withObject:changeDetails.fetchResultAfterChanges];
            }
        }];
        
        if (![self.fetchResults isEqualToArray:fetchResults]) {
            self.fetchResults = fetchResults;
            
            // Reload albums
            [self updateAssetCollections];
            [self.tableView reloadData];
        }
    });
}

@end
