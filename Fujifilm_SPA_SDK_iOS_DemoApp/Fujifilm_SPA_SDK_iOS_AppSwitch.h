//
//  Fujifilm_SPA_SDK_iOS_AppSwitch.h
//
//  Created by JNICK on 3/23/17.
//  Copyright (c) 2016 FUJIFILM North America Corp. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol Fujifilm_SPA_SDK_iOS_AppSwitchHandler;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Fujifilm_SPA_SDK_iOS_AppSwitch

/*!
 @class Fujifilm_SPA_SDK_iOS_AppSwitch
 @brief Handles return URLs when returning from app switch and routes the return URL to the correct app switch handler class.
 @discussion `returnURLScheme` must contain the app's registered URL Type that starts with the app's bundle
 ID. When the app returns from app switch, the app delegate should call `handleOpenURL:sourceApplication:`
 */
@interface Fujifilm_SPA_SDK_iOS_AppSwitch : NSObject


/*!
 @brief The URL scheme to return to this app after switching to another app.
 
 @discussion This URL scheme must be registered as a URL Type in the app's info.plist, and it must start with the app's bundle ID.
 */
@property (nonatomic, copy) NSString *returnURLScheme;

/*!
 @brief The singleton instance
 */
+ (instancetype)sharedInstance;

/*!
 @brief Sets the return URL scheme for your app.
 
 @discussion This must be configured if your app integrates a payment option that may switch to either
 Mobile Safari or to another app to finish the payment authorization workflow.
 
 @param returnURLScheme The return URL scheme
 */
+ (void)setReturnURLScheme:(NSString *)returnURLScheme;

/*!
 @brief Handles a return from app switch
 
 @param url The URL that was opened to return to your app
 @param sourceApplication The source app that requested the launch of your app
 @return `YES` if the app switch successfully handled the URL, or `NO` if the attempt to handle the URL failed.
 */
+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication;

/*!
 @brief Handles a return from app switch
 
 @param url The URL that was opened to return to your app
 @param options The options dictionary provided by `application:openURL:options:`
 @return `YES` if the app switch successfully handled the URL, or `NO` if the attempt to handle the URL failed.
 */
+ (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary *)options;

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

@end


NS_ASSUME_NONNULL_END
