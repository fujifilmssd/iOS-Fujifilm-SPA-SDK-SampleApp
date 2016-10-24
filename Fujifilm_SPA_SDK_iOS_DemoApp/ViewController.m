//
//  ViewController.m
//
//  Created by Jonathan Nick on 1/7/16.
//  Copyright (c) 2016 FUJIFILM North America Corp. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UISegmentedControl *environmentControl;
@property (weak, nonatomic) IBOutlet UIView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCarousel;
//@property (weak, nonatomic) IBOutlet UIView *imageCarouselView;
@property (strong, nonatomic) UIActionSheet *attachmentMenuSheet;
@property (strong, nonatomic) UIImagePickerController *cameraPicker;
@property(nonatomic, strong) NSMutableArray *imageAssets;
@property(nonatomic, strong) NSMutableArray *thumbnails;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic) CGFloat carouselWidth;
@property (nonatomic) SettingsViewController *settingsViewController;
@end

@implementation ViewController
@synthesize attachmentMenuSheet;
@synthesize cameraPicker;
@synthesize carouselWidth;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.imageAssets = [NSMutableArray array];
    self.thumbnails = [NSMutableArray array];
    [self.imageCarousel reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"settings_controller"]) {
        self.settingsViewController = (SettingsViewController *) [segue destinationViewController];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Button Actions
- (IBAction)orderButtonTapped:(id)sender {
    
    if(self.imageAssets != nil && self.imageAssets.count>0 && [self.settingsViewController getApiKey].length > 0) {
        /*
         -------------------------------------------------------------------------------
         Create a Fujifilm_SPA_SDK_iOS instance and present the Fujifilm SDK controller.
         -------------------------------------------------------------------------------
         
         - Go to http://www.fujifilmapi.com to register for an apiKey.
         - Ensure you have the right apiKey for the right environment.
         
         @param apiKey(NSString): Fujifilm SPA apiKey you receive when you create your app at http://fujifilmapi.com. This apiKey is environment specific
         @param environment(NSString): Sets the environment to use. The apiKey must match your app’s environment set on http://fujifilmapi.com. Possible values are “preview” or "production".
         @param images(id): An NSArray of PHAsset, ALAsset, or NSString (public image urls https://). (Array can contain combination of types). Images must be jpeg/png format and smaller than 20MB. A maximum of 100 images can be sent in a given Checkout process. If more than 100 images are sent, only the first 100 will be processed.
         @param userID(NSString): Optional param, send in @"" if you don't use it. This can be used to link a user with an order. MaxLength = 50 alphanumeric characters.
         @param retainUserInfo(BOOL):  Save user information (address, phone number, email) for when the app is used a 2nd time.
         @param promoCode(NSString): Optional parameter to add a promo code to the order. Contact us through http://fujifilmapi.com for usage and support.
         @param launchPage(LaunchPage): The page that the SDK should launch when initialized. Valid values are (kHome, kCart), defaults to kHome
         @param extraOptions: for future use, nil is the only acceptable value currently
         extraOptions: for future use, nil is the only acceptable value currently
         *---------------------------------------------------------------------------------------
         
         Example using public urls
         // self.imageAssets = [[NSMutableArray alloc] initWithObjects:@"https://pixabay.com/static/uploads/photo/2015/09/05/21/08/fujifilm-925350_960_720.jpg",@"https://pixabay.com/static/uploads/photo/2016/02/07/12/02/mustang-1184505_960_720.jpg", nil];
         
         */
        LaunchPage page = kHome;
        if ([self.settingsViewController.launchPage isEqualToString:@"Cart"]) {
            page = kCart;
        }
        
        
        Fujifilm_SPA_SDK_iOS *fujifilmOrderController = [[Fujifilm_SPA_SDK_iOS alloc] initWithApiKey: [self.settingsViewController getApiKey]
                                                                                         environment:  [self.settingsViewController getEnvironment]
                                                                                              images: self.imageAssets
                                                                                              userID: [self.settingsViewController getUserId]
                                                                                      retainUserInfo: [self.settingsViewController getRetainUserInfo]
                                                                                           promoCode: [self.settingsViewController getPromoCode]
                                                                                          launchPage: page
                                                                                        extraOptions: nil];
        fujifilmOrderController.delegate = self;
        
        FujifilmSPASDKNavigationController *navController = [[FujifilmSPASDKNavigationController alloc] initWithRootViewController:fujifilmOrderController];
        
        
        /*
         ---------------------------------------------------------------------------------------
         Present the Fujifilm SPA SDK
         ---------------------------------------------------------------------------------------
         */
        [self presentViewController:navController animated:YES completion:nil];
    }
    else if ([self.settingsViewController getApiKey].length == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please enter an apiKey!"
                                                          message:@""
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No photos selected!"
                                                          message:@""
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}
- (IBAction)pickImageTapped:(id)sender {
    if(NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0){
        attachmentMenuSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Take Photo", @"Photo Library", nil];
        
        // Show the sheet
        [attachmentMenuSheet showInView:self.view];
    } else {
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIPopoverPresentationController *popPresenter = [actionSheet popoverPresentationController];
        UIButton *button = (UIButton *)sender;
        popPresenter.sourceView = button;
        popPresenter.sourceRect = button.bounds;
        
        UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Cancel button tappped.
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }];
        
        [actionSheet addAction:cancelAction];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self openCamera];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self dismissViewControllerAnimated:YES completion:^{}];
            [self openPhotoPicker];
        }]];
        
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
        actionSheet.view.tintColor = [UIColor blackColor];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self openPhotoPicker];
            break;
        default:
            break;
    }
}

-(IBAction) openPhotoPicker {
    if(self.isPhotoAccessAvailable){
        if(NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_3){
            AGImagePickerController *agImagePickerController = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
                if (error == nil) {
                    NSLog(@"User has cancelled.");
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    NSLog(@"Error: %@", error);
                    
                    double delayInSeconds = 0.5;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
                
            } andSuccessBlock:^(NSArray *info) {
                NSLog(@"Info: %@", info);
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [agImagePickerController setDelegate:self];
            [agImagePickerController setShouldChangeStatusBarStyle:NO];
            [agImagePickerController setShouldDisplaySelectionInformation:NO];
            agImagePickerController.toolbar.tintColor = [UIColor colorWithRed:135.0/255 green:180.0/255 blue:80.0/255 alpha:1.0];
            agImagePickerController.navigationBar.tintColor = [UIColor colorWithRed:135.0/255 green:180.0/255 blue:80.0/255 alpha:1.0];
            [self presentViewController:agImagePickerController animated:YES completion:nil];
            
        } else {
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            //hide empty albums
            picker.showsEmptyAlbums = NO;
            
            // create options for fetching photo only
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
            
            // assign options
            picker.assetsFetchOptions = fetchOptions;
            
            // to present picker as a form sheet in iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self presentViewController:picker animated:YES completion:nil];
        }
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please grant Photos Permission!"
                                                          message:@""
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

-(IBAction)openCamera {
    // Can't use camera if we don't have access to pull the photo afterwards.
    if (!self.isPhotoAccessAvailable) {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This app needs permissions to photos in order to use the camera. Please enable access to photos and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [uialert show];
        return;
    }
    else {
        [self displayCameraView];
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot open camera, permission has been denied. Please grant this app access to the camera in settings and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [uialert show];
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self displayCameraView];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot open camera, permission has been denied." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [uialert show];
                });
            }
        }];
    }
    else if (authStatus == AVAuthorizationStatusAuthorized) {
        [self displayCameraView];
    }
}

-(void)displayCameraView {
    cameraPicker = [[UIImagePickerController alloc] init];
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = NO;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:cameraPicker animated:YES completion:nil];
}

- (IBAction)addUrlTapped:(id)sender {
    UIAlertView *uialert=[[UIAlertView alloc]initWithTitle:@"" message:@"Enter image URL" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    uialert.alertViewStyle=UIAlertViewStylePlainTextInput;
    uialert.tag = 1;
    UITextField *textField = [uialert textFieldAtIndex:0];
    textField.placeholder = @"Image URL";
    textField.keyboardType = UIKeyboardTypeURL;
    [uialert show];
}

- (IBAction)clearImagesTapped:(id)sender {
    if (self.imageAssets && self.imageAssets.count > 0) {
        UIAlertView *uialert=[[UIAlertView alloc]initWithTitle:@"" message:@"Clear all images?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        uialert.alertViewStyle=UIAlertViewStyleDefault;
        uialert.tag = 2;
        [uialert show];
    } else {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"You have no images to clear."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [uialert show];
        return;
    }
}

#pragma mark -

#pragma mark Fujifilm SPA SDK delegate

-(void) fujifilmSPASDKFinishedWithStatus: (int) statusCode andMessage: (NSString*) message{
    NSString *msg;
    /**
     Status codes that may be sent from Fujifilm SPA SDK. This may require updates if any new codes are added. See documentation for list of status codes.
     */
    switch (statusCode){
        case kFujifilmSDKStatusCodeFatal:
            msg = @"Fatal Error";
            break;
        case kFujifilmSDKStatusCodeNoImagesUploaded:
            msg = @"No Images Uploaded";
            break;
        case kFujifilmSDKStatusCodeNoInternet:
            msg = @"No Internet";
            break;
        case kFujifilmSDKStatusCodeInvalidAPIKey:
            msg = @"Invalid APIKey";
            break;
        case kFujifilmSDKStatusCodeUserCanceled:
            msg = @"User Canceled";
            break;
        case kFujifilmSDKStatusCodeNoValidImages:
            msg = @"No Valid Images";
            break;
        case kFujifilmSDKStatusCodeTimeout:
            msg = @"Timeout Error";
            break;
        case kFujifilmSDKStatusCodeOrderComplete:
            msg = message;
            break;
        case kFujifilmSDKStatusCodeUploadFailed:
            msg = @"Upload Failed";
            break;
        case kFujifilmSDKStatusCodeInvalidUserIDFormat:
            msg = @"Invalid User ID Format";
            break;
        case kFujifilmSDKStatusCodeInvalidPromoCodeFormat:
            msg = @"Invalid Promo Code Format";
            break;
        default:
            msg = @"Unknown Error";
    }
    
    if(statusCode != kFujifilmSDKStatusCodeFatal
       && statusCode!= kFujifilmSDKStatusCodeOrderComplete
       && statusCode != kFujifilmSDKStatusCodeUserCanceled
       && statusCode != kFujifilmSDKStatusCodeNoInternet
       && statusCode !=  kFujifilmSDKStatusCodeTimeout) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message: msg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}
-(void) promoCodeDidFailValidationWithError:(int)error {
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //alertview with tag 1 = add url dialog
    if(alertView.tag == 1 && buttonIndex == 1)
    {
        NSString *text = [[alertView textFieldAtIndex:0] text];
        
        //validate image is jpg
        //        NSURL *url = [NSURL URLWithString:text];
        //        if (url && url.scheme && url.host) {
        //            NSString *path = [url path];
        //            NSString *extension = [path pathExtension];
        //        if([extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame || [extension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame){
        //                [self.imageAssets addObject:text];
        //                [self setImageViewerImages];
        //            }
        //        }
        //
        [self.imageAssets addObject:text];
        [self setImageViewerImages];
        
    }
    //alertview with tag 2 = clear image dialog
    if(alertView.tag == 2 && buttonIndex == 1)
    {
        self.imageAssets = [NSMutableArray array];
        self.thumbnails = [NSMutableArray array];
        [self.imageCarousel reloadData];
    }
}

#pragma mark - AGImagePicker Delegate

- (void)agImagePickerController:(AGImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    for (ALAsset* asset in info) {
        [self.imageAssets addObject:asset];
    }
    [self setImageViewerImages];
}

- (void)agImagePickerController:(AGImagePickerController *)picker didFail:(NSError *)error{
    NSLog(@"AGImagePickerController Error %@", [error localizedDescription]);
}

#pragma mark - CTAssetsPicker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    for (PHAsset* asset in assets) {
        [self.imageAssets addObject:asset];
    }
    [self setImageViewerImages];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Request to save the image to camera roll
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary* library=[ViewController defaultAssetsLibrary];
    NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    [library writeImageToSavedPhotosAlbum:image.CGImage metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error != nil) {
            // Errored out here. Could be some unknown reason or because the user denied permission to photos.
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self.isPhotoAccessAvailable) {
                    UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot access picture taken from camera, permission to photos is required. Please allow access to photos in settings and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [uiAlert show];
                }
                else {
                    UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:@"Unknown error" message:@"An unknown error has occured. Please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [uiAlert show];
                }
            });
        }
        else {
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset ){
                
                [self.imageAssets addObject:asset];
                [self setImageViewerImages];
            }
                    failureBlock:^(NSError *error ) {
                        NSLog(@"Error saving image to Camera Roll!");
                    }];
        }
    }];
    
    [self imagePickerControllerDidCancel:picker];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers
-(BOOL)isPhotoAccessAvailable {
    return [ALAssetsLibrary authorizationStatus] != ALAuthorizationStatusDenied ? YES: NO;
}
- (void) setImageViewerImages{
    if(self.imageAssets != nil && self.imageAssets.count >0){
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
            
            NSMutableArray *tempThumbnails = [NSMutableArray array];
            NSMutableArray *invalidImages = [NSMutableArray array];
            for(id object in self.imageAssets){
                @autoreleasepool {
                    if([object isKindOfClass:[PHAsset class]]) {
                        PHImageRequestOptions *option = [PHImageRequestOptions new];
                        option.synchronous = YES;
                        option.resizeMode = PHImageRequestOptionsResizeModeFast;
                        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                        CGSize targetSize = CGSizeMake(60, 60);
                        [[PHImageManager defaultManager] requestImageForAsset:object
                                                                   targetSize:targetSize
                                                                  contentMode:PHImageContentModeAspectFill
                                                                      options:option
                                                                resultHandler:^(UIImage *img, NSDictionary *info){
                                                                    if(img != nil){
                                                                        [tempThumbnails addObject: img];
                                                                    } else {
                                                                        [invalidImages addObject:object];
                                                                    }
                                                                    
                                                                }];
                    }
                    else if([object isKindOfClass:[ALAsset class]]){
                        //alasset
                        ALAsset *asset = (ALAsset *) object;
                        UIImage *img = [UIImage imageWithCGImage: [asset thumbnail]];
                        if (img != nil) {
                            [tempThumbnails addObject: img];
                        } else {
                            [invalidImages addObject:object];
                        }
                        
                    }
                    else if ([object isKindOfClass:[NSString class]]){
                        //image url
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:object]];
                        if(data != nil){
                            UIImage *image = [UIImage imageWithData:data];
                            if (image != nil) {
                                CGSize destinationSize = CGSizeMake(60, 60);
                                UIGraphicsBeginImageContext(destinationSize);
                                [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                                [tempThumbnails addObject: UIGraphicsGetImageFromCurrentImageContext()];
                                UIGraphicsEndImageContext();
                            } else {
                                [invalidImages addObject:object];
                            }
                        } else {
                            [invalidImages addObject:object];
                        }
                    }
                }
                
            }
            [self.imageAssets removeObjectsInArray:invalidImages];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^(void){
                self.thumbnails = [NSMutableArray array];
                [self.thumbnails addObjectsFromArray:tempThumbnails];
                [self.imageCarousel reloadData];
                
            });
            
        });
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *cellIdentifier = @"ITCell";
    
    UICollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    for (UIView *v in [cell subviews]){
        [v removeFromSuperview];
        
    }
    if (indexPath.row < self.thumbnails.count) {
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        view.image = [self.thumbnails objectAtIndex:indexPath.row];
        [cell addSubview:view];
    }
    
    
    return cell;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.thumbnails count];
}
+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
