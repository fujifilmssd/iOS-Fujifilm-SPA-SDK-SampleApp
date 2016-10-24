//
//  Fujifilm.SPA.SDK.h
//
//  Created by Jonathan Nick on 1/7/16.
//  Copyright (c) 2016 FUJIFILM North America Corp. All rights reserved.
//
/** The FujifilmSPASDKDelegate protocol defines methods that your delegate object must implement to interact with the Fujifilm SPA SDK interface. The methods of this protocol notify your delegate when the user exits the checkout flow or when an error occurs. See documentation for details on status codes.
 */
@protocol FujifilmSPASDKDelegate

/**
 Tells the delegate how the user exited the checkout flow.
 Control is passed back to your application once this delegate method is called.
 @param statusCode - see documentation for list of status codes.
 */
-(void) fujifilmSPASDKFinishedWithStatus: (int) statusCode andMessage: (NSString*) message;
/**
 Optional function that is called when an invalid promotion code is passed into the SDK
 @param error - see documentation for list of error codes
 */
@optional
-(void) promoCodeDidFailValidationWithError: (int) error;
@end


/** This class facilitates checkout with Fujifilm's SPA SDK. Image upload is handled automatically.
 */
@interface Fujifilm_SPA_SDK_iOS : UIViewController{
    id <FujifilmSPASDKDelegate> delegate;
}

/**---------------------------------------------------------------------------------------
 * @name Configuring the ViewController
 *  ---------------------------------------------------------------------------------------
 */

/**
 The viewcontroller's delegate object.
 The delegate receives notification when the user exits the checkout flow.
 @note This property must be set and should not be _nil_. You must provide a delegate that conforms to the FujifilmSPASDKDelegate protocol.
 */
@property (assign) id <FujifilmSPASDKDelegate> delegate;
/**---------------------------------------------------------------------------------------
 * @name Initializers
 *  ---------------------------------------------------------------------------------------
 */

/** Creates a Fujifilm_SPA_SDK_iOS instance that handles all order checkout process.
 
 *Note* : apiKey, environment, and images are required. userid is an optional parameter.
 
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
 */

typedef enum {
    kHome,
    kCart
} LaunchPage;

- (id)initWithApiKey:(NSString *)apiKey environment:(NSString*)environment images:(NSArray *)images userID:(NSString*)userid retainUserInfo:(BOOL)retainUserInfo promoCode:(NSString *)promoCode launchPage:(LaunchPage)initialPage extraOptions:(NSDictionary<NSString *, id>*)extraOptions;

@end

@interface FujifilmSPASDKNavigationController : UINavigationController

@end

