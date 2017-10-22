//
//  SettingsViewController.h
//  Fujifilm_SPA_SDK_iOS_DemoApp
//
//  Created by Sam on 4/1/16.
//  Copyright © 2016 ___Fujifilm___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fujifilm.SPA.SDK.h"

@interface SettingsViewController : UITableViewController<UITextFieldDelegate, UITableViewDelegate>{}
@property (weak, nonatomic) IBOutlet UISegmentedControl *environmentControl;
@property (weak, nonatomic) IBOutlet UISwitch *retainUserInfo;
@property (weak, nonatomic) IBOutlet UISwitch *enableAddMorePhotos;
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

-(NSString *) getUrl;

-(BOOL) getRetainUserInfo;

-(NSNumber *) getEnableAddMorePhotos;

-(NSString *) getEnvironment;

-(NSString *) getPromoCode;

-(NSString *) getDeepLink;

@end
