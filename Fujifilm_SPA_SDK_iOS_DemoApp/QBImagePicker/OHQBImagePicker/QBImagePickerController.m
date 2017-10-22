//
//  QBImagePickerController.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBImagePickerController.h"
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

// ViewControllers
#import "QBAlbumsViewController.h"
#import "QBAssetsViewController.h"
#import "QBAlbumCell.h"

@interface QBImagePickerController ()

@property (nonatomic, strong) UINavigationController *albumsNavigationController;

@end

@implementation QBImagePickerController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Set default values
        self.assetCollectionSubtypes = @[
                                         @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                         @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                         @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                         @(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                         @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                         @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                         @(PHAssetCollectionSubtypeAlbumImported),
                                         @(PHAssetCollectionSubtypeAlbumSyncedAlbum),
                                         @(PHAssetCollectionSubtypeAlbumRegular),
                                         @(PHAssetCollectionSubtypeAlbumSyncedEvent),
                                         @(PHAssetCollectionSubtypeAlbumSyncedFaces),
                                         @(PHAssetCollectionSubtypeSmartAlbumGeneric),
                                         @(PHAssetCollectionSubtypeSmartAlbumLivePhotos),
                                         @(PHAssetCollectionSubtypeSmartAlbumDepthEffect),
                                         @(PHAssetCollectionSubtypeSmartAlbumScreenshots),
                                         @(PHAssetCollectionSubtypeSmartAlbumSelfPortraits)
                                         ];
        self.minimumNumberOfSelection = 1;
        self.numberOfColumnsInPortrait = 4;
        self.numberOfColumnsInLandscape = 7;
        self.excludeEmptyAlbums = YES;
        self.maxImagesMessage = @"Sorry, you can only select up to 100 photos at one time.";
        _selectedItems = [NSMutableOrderedSet orderedSet];
    }
    
    return self;
}
- (void)setSelectedItemsWithIDs:(NSArray<NSString *>*)ids {
    PHFetchResult<PHAsset *> *results = [PHAsset fetchAssetsWithLocalIdentifiers:ids options:nil];
    [results enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.selectedItems addObject:obj];
    }];
}
- (void)viewDidLoad
{
	[super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	// default navigation route: Nav VC --> Root VC (Albums) --> Assets
    UINavigationController *navVC = [self createPickerNavigation];
    self.albumsNavigationController = navVC;
	//UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"QBImagePicker" bundle:self.assetBundle];
	//self.albumsNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"QBAlbumsNavigationController"];
	
	[self addChildViewController:self.albumsNavigationController];
	self.albumsNavigationController.view.frame = self.view.bounds;
	[self.view addSubview:self.albumsNavigationController.view];
	[self.albumsNavigationController didMoveToParentViewController:self];
	
//    // Set instance
//    QBAlbumsViewController *albumsViewController = (QBAlbumsViewController *)self.albumsNavigationController.topViewController;
//    albumsViewController.imagePickerController = self;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
	return self.albumsNavigationController;
}

- (NSBundle *)assetBundle
{
	if (_assetBundle == nil)
		_assetBundle = [[self class] QBImagePickerBundle];
	return _assetBundle;
}

+ (NSBundle *)QBImagePickerBundle
{
	// Get asset bundle
	NSBundle *assetBundle = [NSBundle bundleForClass:[QBImagePickerController class]];
	NSString *bundlePath = [assetBundle pathForResource:@"OHQBImagePicker" ofType:@"bundle"];
	if (bundlePath) {
		assetBundle = [NSBundle bundleWithPath:bundlePath];
	}
	return assetBundle;
}

- (UINavigationController *)createPickerNavigation
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumLineSpacing = 2;
    flow.minimumInteritemSpacing = 2;
    flow.sectionInset = UIEdgeInsetsMake(8.0, 0.0, 2.0, 0.0);
    flow.footerReferenceSize = CGSizeMake(50.0, 66.0);
    flow.itemSize = CGSizeMake(77.5, 77.5);
    
    // create album collection view controller
    UICollectionViewController *albumView = [[QBAssetsViewController alloc] initWithCollectionViewLayout:flow];
    UICollectionView *collectionView = albumView.collectionView;
    collectionView.backgroundColor = UIColor.whiteColor;
    
    collectionView.showsVerticalScrollIndicator = YES;
    collectionView.showsHorizontalScrollIndicator = YES;
    collectionView.scrollEnabled = YES;
    collectionView.bouncesZoom = YES;
    collectionView.contentMode = UIViewContentModeScaleToFill;
    collectionView.alpha = 1;
    collectionView.opaque = YES;
    collectionView.clipsToBounds = YES;
    collectionView.clearsContextBeforeDrawing = YES;
    collectionView.autoresizesSubviews = YES;
    collectionView.multipleTouchEnabled = YES;
    collectionView.userInteractionEnabled = YES;
    collectionView.tag = 1;
    collectionView.dataSource = albumView;
    collectionView.delegate = albumView;
    
    [collectionView registerClass: [UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier: @"FooterView"];
    
    // create album collection view controller navigation item
    UINavigationItem *albumNavItem = [[UINavigationItem alloc] initWithTitle:@"Album Title"];
    if (@available(iOS 11.0, *)) {
        albumNavItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:albumView action:@selector(doneTapped:)];
    doneBtn.tag = 3;
    doneBtn.style = UIBarButtonItemStylePlain;
    doneBtn.enabled = YES;
    [albumNavItem setRightBarButtonItem:doneBtn];
    albumView.navigationItem.rightBarButtonItem = albumNavItem.rightBarButtonItem;
    
    
    // create photos table view controller
    UITableViewController *photosView = [[QBAlbumsViewController alloc] init];
    //** create nav controller
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photosView];
    self.assetsVC = albumView;
    // Set instance
    QBAlbumsViewController *albumsViewController = (QBAlbumsViewController *)photosView;
    albumsViewController.imagePickerController = self;
    //**
    photosView.clearsSelectionOnViewWillAppear = YES;
    photosView.automaticallyAdjustsScrollViewInsets = YES;
    photosView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    photosView.modalPresentationStyle = UIModalPresentationFullScreen;
    
    photosView.tableView.dataSource = photosView;
    photosView.tableView.delegate = photosView;
    [photosView.tableView registerClass:[QBAlbumCell class] forCellReuseIdentifier:@"AlbumCell"];
    
    // create photos table view controller navigation item
    UINavigationItem *photosNavItem = [[UINavigationItem alloc] initWithTitle:@"Photos"];
    if (@available(iOS 11.0, *)) {
        photosNavItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:photosView action:@selector(cancelTapped:)];
    cancelBtn.style = UIBarButtonItemStylePlain;
    cancelBtn.enabled = YES;
    cancelBtn.tag = 4;
    UIBarButtonItem *photosDoneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:photosView action:@selector(doneTapped:)];
    photosDoneBtn.style = UIBarButtonItemStylePlain;
    photosDoneBtn.enabled = YES;
    photosDoneBtn.tag = 5;
    [photosNavItem setLeftBarButtonItem:cancelBtn];
    [photosNavItem setRightBarButtonItem:photosDoneBtn];
    photosView.navigationItem.leftBarButtonItem = photosNavItem.leftBarButtonItem;
    photosView.navigationItem.rightBarButtonItem = photosNavItem.rightBarButtonItem;
    
    return nav;
}
-(void) dismissPicker{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)doneTapped:(id)sender
{
    [self dismissPicker];
    if ([self.delegate respondsToSelector:@selector(qb_imagePickerController:didFinishPickingItems:)]) {
        [self.delegate qb_imagePickerController:self                                            didFinishPickingItems:self.selectedItems.array];
    }
}

- (void)cancelTapped:(id)sender
{
    [self dismissPicker];
    if ([self.delegate respondsToSelector:@selector(qb_imagePickerControllerDidCancel:)]) {
        [self.delegate qb_imagePickerControllerDidCancel:self];
    }
}

-(void)segueToView
{
    if (self.assetsVC != nil)
    {
        if (![self.albumsNavigationController.viewControllers containsObject:self.assetsVC])
        {
            [self.albumsNavigationController pushViewController:self.assetsVC animated:YES];
            //[self presentViewController:self.assetsVC animated:YES completion:nil];
        }
    }
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
