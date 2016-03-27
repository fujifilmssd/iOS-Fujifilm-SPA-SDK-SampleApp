//
//  ViewController.m
//
//  Created by Jonathan Nick on 1/7/16.
//  Copyright (c) 2016 FUJIFILM North America Corp. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *environmentControl;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyText;
@property (weak, nonatomic) IBOutlet UITextField *userIdText;
@property (strong, nonatomic) UIActionSheet *attachmentMenuSheet;
@property (strong, nonatomic) UIImagePickerController *cameraPicker;
@property(nonatomic, strong) NSMutableArray *imageAssets;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation ViewController
@synthesize attachmentMenuSheet;
@synthesize cameraPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.apiKeyText setDelegate:self];
    [self.userIdText setDelegate:self];
    self.imageAssets = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Button Actions
- (IBAction)orderButtonTapped:(id)sender {
    
    if(self.imageAssets != nil && self.imageAssets.count>0 && self.apiKeyText.text.length > 0) {
        /*
         ---------------------------------------------------------------------------------------
         Creates a Fujifilm_SPA_SDK_iOS instance that handles all order checkout process.
         ---------------------------------------------------------------------------------------
         *Note* : All parameters are required.
         
         - Go to http://www.fujifilmapi.com to register for an apiKey.
         - Ensure you have the right apiKey for the right environment.
         
         @param apiKey: Fujifilm SPA apiKey you receive when you create your app at http://fujifilmapi.com
         @param environment: A string indicating which environment your app runs in. Must match your app’s environment set on http://fujifilmapi.com. Possible values are “test” or “live”.
         @param images: An NSArray of PHAsset, ALAsset, or NSString (public image urls http://). (Array can contain combination of types). Images must be JPG format and smaller than 20MB.
         @param userid: Optional param, send in @"" if you don't use it. This can be used to link a user with an order. MaxLength = 50 alphanumeric characters
         @return Fujifilm_SPA_SDK_iOS object
         *---------------------------------------------------------------------------------------
         
        Example using public urls
         // self.imageAssets = [[NSMutableArray alloc] initWithObjects:@"https://pixabay.com/static/uploads/photo/2015/09/05/21/08/fujifilm-925350_960_720.jpg",@"https://pixabay.com/static/uploads/photo/2016/02/07/12/02/mustang-1184505_960_720.jpg", nil];
         
        */
        
        NSString *environment = self.environmentControl.selectedSegmentIndex == 0 ? @"live" : @"test";
        
        Fujifilm_SPA_SDK_iOS *fujifilmOrderController = [[Fujifilm_SPA_SDK_iOS alloc] initWithOptions:self.apiKeyText.text environment:environment images:self.imageAssets userID:self.userIdText.text];
        fujifilmOrderController.delegate = self;
        /*
         ---------------------------------------------------------------------------------------
         Present the Fujifilm SPA SDK
         ---------------------------------------------------------------------------------------
         */
        [self presentViewController:fujifilmOrderController animated:YES completion:nil];
        
    }
    else if (self.apiKeyText.text.length == 0) {
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
    cameraPicker = [[UIImagePickerController alloc] init];
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = NO;
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:cameraPicker animated:YES completion:NULL];
}

- (IBAction)addUrlTapped:(id)sender {
    UIAlertView *uialert=[[UIAlertView alloc]initWithTitle:@"" message:@"Enter image URL" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    uialert.alertViewStyle=UIAlertViewStylePlainTextInput;
    uialert.tag = 1;
    UITextField *textField = [uialert textFieldAtIndex:0];
    textField.placeholder = @"Image URL";
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
        default:
            msg = @"Unknown Error";
    }
    
    NSLog(@"fujifilmSPASDKFinishedWithStatus: statusCode: %u message: %@", statusCode, msg);
    
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
        [self.imageViewer stopAnimating];
        self.imageViewer.animationImages = nil;
        self.imageViewer.image = nil;
        self.imageAssets = [NSMutableArray array];
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
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset ){
            
            [self.imageAssets addObject:asset];
            [self setImageViewerImages];
        }
                failureBlock:^(NSError *error ) {
                    NSLog(@"Error saving image to Camera Roll!");
                }];
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
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^(void){
            
            NSMutableArray *thumbnails = [[NSMutableArray alloc] init];
            
            for(id object in self.imageAssets){
                if([object isKindOfClass:[PHAsset class]]) {
                    PHImageRequestOptions *option = [PHImageRequestOptions new];
                    option.synchronous = YES;
                    option.resizeMode = PHImageRequestOptionsResizeModeFast;
                    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                    CGSize targetSize = CGSizeMake(400, 400);
                    [[PHImageManager defaultManager] requestImageForAsset:object
                                                               targetSize:targetSize
                                                              contentMode:PHImageContentModeAspectFill
                                                                  options:option
                                                            resultHandler:^(UIImage *img, NSDictionary *info){
                                                                if(img != nil){
                                                                    [thumbnails addObject: img];
                                                                }
                                                                
                                                            }];
                }
                else if([object isKindOfClass:[ALAsset class]]){
                    //alasset
                    ALAsset *asset = (ALAsset *) object;
                    [thumbnails addObject: [UIImage imageWithCGImage: [asset thumbnail]]];
                }
                else if ([object isKindOfClass:[NSString class]]){
                    //image url
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:object]];
                    if(data != nil){
                        UIImage *image = [UIImage imageWithData:data];
                        if (image != nil) {
                            [thumbnails addObject: image];
                        }
                    }
                }
            }
            if(thumbnails.count>0){
                self.imageViewer.image = [thumbnails objectAtIndex:0];
                self.imageViewer.animationImages = thumbnails;
                self.imageViewer.animationDuration = thumbnails.count;
                self.imageViewer.animationRepeatCount = 1;
                [self.imageViewer startAnimating];
            }
        });
    }
}
+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)setViewMovedUp:(CGFloat)keyboardSize
{
    CGRect rect = self.view.frame;
    if (keyboardSize == 0) {
        rect.origin.y = 0;
    } else if ((rect.origin.y >=0 && keyboardSize > 0)) {
        rect.origin.y -= keyboardSize;
    }
    self.view.frame = rect;
}
- (void)keyboardWasShown:(NSNotification *)notification {
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    keyboardHeight -= self.orderButton.bounds.size.height;
    keyboardHeight -= self.toolbar.bounds.size.height;
    [self setViewMovedUp:keyboardHeight];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    keyboardHeight -= self.orderButton.bounds.size.height;
    keyboardHeight -= self.toolbar.bounds.size.height;
    [self setViewMovedUp:0];
}

@end
