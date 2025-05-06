//
//  ViewController.h
//
//  Created by Jonathan Nick on 1/17/16.
//  Copyright (c) 2016 FUJIFILM North America Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <Fujifilm_SPA_SDK_iOS/Fujifilm.SPA.SDK.h>
#import "SettingsViewController.h"
#import "QBImagePicker.h"

@interface ViewController : UIViewController < UIImagePickerControllerDelegate , UINavigationControllerDelegate, UIAlertViewDelegate,
UIActionSheetDelegate,
UIPopoverControllerDelegate, UITextFieldDelegate, QBImagePickerControllerDelegate,FujifilmSPASDKDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{}

/**
 Enum of status codes that may be sent from Fujifilm SPA SDK. This may require updates if any new codes are added. See documentation for list of status codes.
 */
typedef enum FujifilmSDKStatusCode {
    kFujifilmSDKStatusCodeFatal= 0,
    kFujifilmSDKStatusCodeNoImagesUploaded= 1,
    kFujifilmSDKStatusCodeNoInternet= 2,
    kFujifilmSDKStatusCodeInvalidAPIKey= 3,
    kFujifilmSDKStatusCodeUserCanceled= 4,
    kFujifilmSDKStatusCodeNoValidImages= 5,
    kFujifilmSDKStatusCodeTimeout= 6,
    kFujifilmSDKStatusCodeOrderComplete= 7,
    kFujifilmSDKStatusCodeUploadFailed= 8,
    kFujifilmSDKStatusCodeInvalidUserIDFormat = 9,
    kFujifilmSDKStatusCodeInvalidPromoCodeFormat = 10,
    kFujifilmSDKStatusCodeRequiresPhotoPermission= 11
} FujifilmSDKStatusCode;
@end

