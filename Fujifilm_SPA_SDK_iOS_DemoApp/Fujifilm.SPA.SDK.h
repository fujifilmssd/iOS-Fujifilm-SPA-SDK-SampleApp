//
//  Fujifilm.SPA.SDK.h
//
//  Created by Jonathan Nick on 9/7/12.
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
 
 @param apiKey YFujifilm SPA apiKey you receive when you create your app at http://fujifilmapi.com.
 @param environment A string indicating which environment your app runs in. Must match your app’s environment set on http://fujifilmapi.com. Possible values are “test” or “live”.
 @param images An NSArray of PHAsset, ALAsset, or NSString (public image urls http://). (Array can contain combination of types). Images must be JPG format and smaller than 20MB.
 @param userid Optional param, send in @"" if you don't use it. This can be used to link a user with an order. MaxLength = 50 alphanumeric characters
 @return Fujifilm_SPA_SDK_iOS object with the options sent in.
 */
- (id)initWithOptions:(NSString *)apiKey environment:(NSString*)environment images:(id)images userID:(NSString*)userid;

@end

