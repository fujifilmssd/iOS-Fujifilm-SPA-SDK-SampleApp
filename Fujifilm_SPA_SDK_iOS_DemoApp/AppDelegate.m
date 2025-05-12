//
//  AppDelegate.m
//
//  Created by Jonathan Nick on 1/17/16.
//  Copyright (c) 2016 FUJIFILM North America Corp. All rights reserved.
//

#import "AppDelegate.h"
#import <Fujifilm_SPA_SDK_iOS/Fujifilm_SPA_SDK_iOS_AppSwitch.h>

@interface AppDelegate ()

@end

//This needs to match what is set in info.plist CFBundleURLSchemes
NSString *FujifilmSPASDKDelegatePaymentsURLScheme = @"com.fujifilm.spa.sdk.sample.FujifilmSDK.Payments";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fujifilm_SPA_SDK_iOS_AppSwitch setReturnURLScheme:FujifilmSPASDKDelegatePaymentsURLScheme];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme localizedCaseInsensitiveCompare:FujifilmSPASDKDelegatePaymentsURLScheme] == NSOrderedSame) {
        return [Fujifilm_SPA_SDK_iOS_AppSwitch handleOpenURL:url options:options];
    }
    return NO;
}
#endif

// If you support iOS 7 or 8, add the following method.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.scheme localizedCaseInsensitiveCompare:FujifilmSPASDKDelegatePaymentsURLScheme] == NSOrderedSame) {
        return [Fujifilm_SPA_SDK_iOS_AppSwitch handleOpenURL:url sourceApplication:sourceApplication];
    }
    return NO;
}

@end
