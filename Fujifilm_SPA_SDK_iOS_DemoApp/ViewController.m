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
    
    if(self.imageAssets != nil && (self.imageAssets.count>0 || [[self.settingsViewController getEnableAddMorePhotos] boolValue]) && [self.settingsViewController getApiKey].length > 0) {
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
         @param extraOptions: Optional parameter to set extra options. A dictionary containing optional key/value pairs for configuring the SDK. Currently accepted keys are defined in our documentation on GitHub.
         *---------------------------------------------------------------------------------------
         
         Example using public urls
         self.imageAssets =  [[NSMutableArray alloc] initWithObjects:@"https://webservices.fujifilmesys.com/venus/imagebank/fujifilmCamera.jpg",@"https://webservices.fujifilmesys.com/venus/imagebank/mustang.jpg", nil];
         

         
         */
        LaunchPage page = kHome;
        if ([self.settingsViewController.launchPage isEqualToString:@"Cart"]) {
            page = kCart;
        }
        
        NSMutableDictionary<NSString *, id> *extraOptions = [NSMutableDictionary new];
        [extraOptions setValue: [self.settingsViewController getDeepLink] forKey: kSiteDeepLink];
        [extraOptions setValue: [self.settingsViewController getEnableAddMorePhotos] forKey:kEnableAddMorePhotos];
        
        if (self.settingsViewController.preRenderedLines.count > 0) {
            FFOrder *order = [FFOrder orderWithLines:self.settingsViewController.preRenderedLines];
            [extraOptions setValue:order forKey:kPreRenderedOrder];
        }
        
        Fujifilm_SPA_SDK_iOS *fujifilmOrderController = [[Fujifilm_SPA_SDK_iOS alloc] initWithApiKey: [self.settingsViewController getApiKey]
                                                                                         environment:  [self.settingsViewController getEnvironment]
                                                                                              images: self.imageAssets
                                                                                              userID: [self.settingsViewController getUserId]
                                                                                      retainUserInfo: [self.settingsViewController getRetainUserInfo]
                                                                                           promoCode: [self.settingsViewController getPromoCode]
                                                                                          launchPage: page
                                                                                        extraOptions: extraOptions];
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
-(void) openPhotoPickerHelper {
    
    // init picker
    QBImagePickerController *picker = [[QBImagePickerController alloc] init];
    picker.delegate = self;
    //hide empty albums
    
    
    // assign options
    picker.allowsMultipleSelection = YES;
    picker.excludeEmptyAlbums = YES;
    picker.mediaType = QBImagePickerMediaTypeImage;
    picker.showsNumberOfSelectedItems = YES;
    picker.minimumNumberOfSelection = 0;
    picker.maximumNumberOfSelection = 100;
    NSMutableArray* selectedIDs = [NSMutableArray new];
    for (PHAsset* asset in self.imageAssets) {
        [selectedIDs addObject:asset.localIdentifier];
    }
    [picker setSelectedItemsWithIDs:selectedIDs];
    
    // to present picker as a form sheet in iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        picker.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // present picker
    [self presentViewController:picker animated:YES completion:nil];
    
}
-(IBAction) openPhotoPicker {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self openPhotoPickerHelper];
            }
        }];
    }
    else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self openPhotoPickerHelper];
    } else {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:[NSString stringWithFormat:@"'%@' Needs Access to Your Photos",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]
                                      message:@"Please enable Photos permission in your settings to be able to choose images."
                                      preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"Cancel"
                          style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction * action)
                          {
                          }]
         ];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"Go to Settings"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                              [[UIApplication sharedApplication] openURL:url];
                          }]
         ];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void) openCameraHelper {
    [self displayCameraView];
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
-(IBAction)openCamera {
    // Can't use camera if we don't have access to pull the photo afterwards.
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self openCameraHelper];
            } else {
                return;
            }
        }];
    }
    else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self openCameraHelper];
    } else {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:[NSString stringWithFormat:@"'%@' Needs Access to Your Photos",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]
                                      message:@"This app needs permissions to photos in order to use the camera. Please enable access to photos and try again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"Cancel"
                          style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction * action)
                          {
                          }]
         ];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"Go to Settings"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                              [[UIApplication sharedApplication] openURL:url];
                          }]
         ];
        [self presentViewController:alert animated:YES completion:nil];
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
/**
 Required delegate
 Tells the delegate how the user exited the checkout flow.
 Control is passed back to your application once this delegate method is called.
 @param statusCode - see documentation for list of status codes.
 */
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
        case kFujifilmSDKStatusCodeRequiresPhotoPermission:
            msg = @"Photo Permission Required";
            break;
        default:
            msg = @"Unknown Error";
    }
    //NSLog(@"fujifilmSPASDKFinishedWithStatus: statusCode: %u message: %@", statusCode, msg);
}

/**
 Optional function that is called when an invalid promotion code is passed into the SDK
 @param error - see documentation for list of error codes
 */
-(void) promoCodeDidFailValidationWithError:(int)error {
    NSString *errorReason;
    switch(error) {
        case 0:
            errorReason = @"Promotion Expired";
            break;
        case 1:
            errorReason = @"Promotion Not Activated";
            break;
        case 2:
            errorReason = @"Invalid Discount";
            break;
        case 3:
            errorReason = @"Promotion Disabled";
            break;
        case 4:
            errorReason = @"Promotion Does Not Exist";
            break;
        case 5:
        default:
            errorReason = @"Fatal Error";
            break;
    }
    //NSLog(@"Promotion is invalid. Cause: %@",errorReason);
}
/*
 Receiving analytic events (Optional)
 If you're interested in seeing what behavior your users are taking in our SDK, we provide a way for you to listen to events from us when users take certain actions. To receive these events, implement the receivedAnalyticsEvent:withAttributes: delegate method.
 
 The attributes are a NSArray of NSDictionary. In each NSDictionary, the keys (defined in our documentation) will correspond to either an NSString value for strings, or NSNumber value for booleans and numbers.
 */
-(void) receivedAnalyticsEvent:(NSString *)event withAttributes:(NSArray *)attributes{
    if (!event) {
        return;
    }
    if ([event isEqualToString:kAnalyticsEventItemPurchased]) {
        [self processItemPurchasedEventWithAttributes:attributes];
    }
    // Handle any other desired events here
}

-(void) processItemPurchasedEventWithAttributes:(NSArray *)attributes {
    NSString *productName = nil;
    NSString *productCode = nil;
    NSNumber *quantity = @0;
    NSNumber *unitPrice = @0.0;
    
    for (NSDictionary *attribute in attributes) {
        NSObject *eventValue = [attribute valueForKey:valueKey];
        if (eventValue == nil || [eventValue isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        NSString *attributeName = [attribute valueForKey:attributeKey];
        if ([attributeName isEqualToString:kAnalyticsAttributePurchasedProduct]) {
            productName = [attribute valueForKey:valueKey];
        }
        else if ([attributeName isEqualToString:kAnalyticsAttributeProductCodePurchased]) {
            productCode = [attribute valueForKey:valueKey];
        }
        else if ([attributeName isEqualToString:kAnalyticsAttributePurchasedQuantity]) {
            quantity = [attribute valueForKey:valueKey];
        }
        else if ([attributeName isEqualToString:kAnalyticsAttributePurchasedUnitPrice]) {
            unitPrice = [attribute valueForKey:valueKey];
        }
    }
    
    //NSLog(@"Received purchased event for product %@ (%@) with quantity %@ and unit price %@", productName, productCode, quantity, unitPrice);
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



#pragma mark - CTAssetsPicker Delegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingItems:(NSArray *)items
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    for (PHAsset* asset in items) {
        if (![self.imageAssets containsObject:asset]) { //Prevent duplicate images from being added to the Sample App
            [self.imageAssets addObject:asset];
        }
    }
    [self setImageViewerImages];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (!error) {
        //We want the PHAsset (not the UIImage), so fetch the first image when sorted by creation date
        PHFetchOptions *fetchOptions = [PHFetchOptions new];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHAsset *asset = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions].firstObject;
        if (asset != nil) {
            [self.imageAssets addObject:asset];
            [self setImageViewerImages];
        }
    } else {
        NSLog(@"save image error: %@", error);
    }
}
-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers
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
                    //                    else if([object isKindOfClass:[ALAsset class]]){
                    //                        //alasset
                    //                        ALAsset *asset = (ALAsset *) object;
                    //                        UIImage *img = [UIImage imageWithCGImage: [asset thumbnail]];
                    //                        if (img != nil) {
                    //                            [tempThumbnails addObject: img];
                    //                        } else {
                    //                            [invalidImages addObject:object];
                    //                        }
                    //
                    //                    }
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
@end
