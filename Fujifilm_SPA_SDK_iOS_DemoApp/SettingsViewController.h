//
//  SettingsViewController.h
//  Fujifilm_SPA_SDK_iOS_DemoApp
//
//  Copyright (c) 2016 FUJIFILM North America Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fujifilm.SPA.SDK.h"

@interface SettingsViewController : UITableViewController<UITextFieldDelegate, UITableViewDelegate>{}
@property (weak, nonatomic) IBOutlet UISegmentedControl *environmentControl;
@property (weak, nonatomic) IBOutlet UISwitch *retainUserInfo;
@property (weak, nonatomic) IBOutlet UITextField *apiKey;
@property (weak, nonatomic) IBOutlet UITextField *userID;
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UITextField *promoCode;
@property (weak, nonatomic) IBOutlet UITextField *deepLink;
@property (nonatomic) NSString *launchPage;
@property (nonatomic) NSString *launchRetailer;
@property (weak, nonatomic) IBOutlet UITextField *versionNumber;

-(NSString *) getApiKey;

-(NSString *) getUserId;

-(BOOL) getRetainUserInfo;

-(NSString *) getEnvironment;

-(NSString *) getPromoCode;

-(NSString *) getDeepLink;

@end
