//
//  SettingsViewController.m
//  Fujifilm_SPA_SDK_iOS_DemoApp
//
//  Copyright (c) 2016 FUJIFILM North America Corp. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController


-(void) viewDidLoad {
    [self.tableView setDelegate:self];
    [self.apiKey setDelegate:self];
    [self.userID setDelegate:self];
    [self.url setDelegate:self];
    [self.promoCode setDelegate:self];
    [self.deepLink setDelegate:self];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    [_versionNumber setText:version];
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if ([UIScreen mainScreen].bounds.size.height <= 500) {
        return 1.0;
    } else {
        return 18.0;
    }
}

-(NSString *) getApiKey {
    return self.apiKey.text;
}

-(NSString *) getUserId {
    return self.userID.text;
}

-(BOOL) getRetainUserInfo {
    return [self.retainUserInfo isOn];
}

-(NSString *) getEnvironment {
    return [[[self.environmentControl titleForSegmentAtIndex: self.environmentControl.selectedSegmentIndex] lowercaseString] stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(NSString *) getPromoCode {
    return self.promoCode.text;
}

-(NSString *) getDeepLink {
    return self.deepLink.text;
}
@end
