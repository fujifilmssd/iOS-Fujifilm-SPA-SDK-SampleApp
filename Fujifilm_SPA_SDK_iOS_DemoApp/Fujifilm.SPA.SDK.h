//
//  Fujifilm.SPA.SDK.h
//
//  Created by Jonathan Nick
//  Copyright (c) 2016 FUJIFILM North America Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@class FFImage;

NS_ASSUME_NONNULL_BEGIN

//Events
static NSString *const kAnalyticsEventExit                             = @"exit";
static NSString *const kAnalyticsEventPhotoEdited                      = @"photoEdited";
static NSString *const kAnalyticsEventProductEdited                    = @"productEdited";
static NSString *const kAnalyticsEventContinueShopping                 = @"continueShopping";
static NSString *const kAnalyticsEventItemAddedToCart                  = @"addToCart";
static NSString *const kAnalyticsEventItemComposed                     = @"itemComposed";
static NSString *const kAnalyticsEventDetailsViewed                    = @"detailsViewed";
static NSString *const kAnalyticsEventItemPurchased                    = @"itemPurchased";
static NSString *const kAnalyticsEventOrderComplete                    = @"orderComplete";
static NSString *const kAnalyticsEventCheckoutStarted                  = @"checkoutStarted";
static NSString *const kAnalyticsEventStoreSearched                    = @"storesSearched";
static NSString *const kAnalyticsEventRemovedFromCart                  = @"removedFromCart";
static NSString *const kAnalyticsEventStoreFavorited                   = @"storeFavorited";
static NSString *const kAnalyticsEventCartItemCountUpdated             = @"cartItemCountUpdated";

//Cloud Print Shop Exit
static NSString *const kAnalyticsAttributeItemsPurchased               = @"itemsPurchased";
static NSString *const kAnalyticsAttributeExitPoint                    = @"exitPoint";
static NSString *const kAnalyticsAttributePromoCode                    = @"promoCode";
static NSString *const kAnalyticsAttributeEntryPoint                   = @"entryPoint";
static NSString *const kAnalyticsAttributeExitMethod                   = @"exitMethod";
static NSString *const kAnalyticsAttributeDeliveryType                 = @"deliveryType";
static NSString *const kAnalyticsAttributePickupLocation               = @"pickupLocation";
static NSString *const kAnalyticsAttributeAddressValidationErrors      = @"addressValidationErrors";

//Cloud Print Continue Shopping
static NSString *const kAnalyticsAttributeScreen                       = @"screen";

//Cloud Print Item Added To Cart
static NSString *const kAnalyticsAttributeStatus                       = @"status";
static NSString *const kAnalyticsAttributeDuration                     = @"duration";
static NSString *const kAnalyticsAttributeAddToCartDelivery            = @"addedDelivery";
static NSString *const kAnalyticsAttributeAddToCartPickup              = @"addedPickup";
static NSString *const kAnalyticsAttributeItemAdded                    = @"itemAdded";

//Cloud Print Item Detail Viewed
static NSString *const kAnalyticsAttributeDetailsSource                = @"detailedSource";
static NSString *const kAnalyticsAttributeDetailsDelivery              = @"detailedDelivery";
static NSString *const kAnalyticsAttributeDetailsPickup                = @"detailedPickup";
static NSString *const kAnalyticsAttributeDetailsProduct               = @"itemDetailsViewed";

//Cloud Print Item Composed
static NSString *const kAnalyticsAttributeComposedSource               = @"composedSource";
static NSString *const kAnalyticsAttributeComposedDelivery             = @"composedDelivery";
static NSString *const kAnalyticsAttributeComposedPickup               = @"composedPickup";
static NSString *const kAnalyticsAttributeComposedProduct              = @"productComposed";

//Cloud Print Items Purchased
static NSString *const kAnalyticsAttributePurchasedDelivery            = @"purchasedDelivery";
static NSString *const kAnalyticsAttributePurchasedPickup              = @"purchasePickup";
static NSString *const kAnalyticsAttributePurchasedProduct             = @"productPurchased";
static NSString *const kAnalyticsAttributePurchasedQuantity            = @"quantityPurchased";

static NSString *const kAnalyticsAttributeAddedProductCode             = @"addedProductCode";
static NSString *const kAnalyticsAttributeProductCodePurchased         = @"productCodePurchased";
static NSString *const kAnalyticsAttributePurchasedUnitPrice           = @"purchasedUnitPrice";
static NSString *const kAnalyticsAttributeNumberOfItems                = @"numberOfItems";
static NSString *const kAnalyticsAttributeNumberOfDistinctItems        = @"numberOfDistinctItems";
static NSString *const kAnalyticsAttributeOrderPaymentType             = @"orderPaymentType";
static NSString *const kAnalyticsAttributeOrderCurrencyType            = @"orderCurrencyType";
static NSString *const kAnalyticsAttributeOrderSubtotal                = @"orderSubtotal";
static NSString *const kAnalyticsAttributeOrderTax                     = @"orderTax";
static NSString *const kAnalyticsAttributeOrderShipping                = @"orderShipping";
static NSString *const kAnalyticsAttributeOrderDiscount                = @"orderDiscount";
static NSString *const kAnalyticsAttributeOrderRetailer                = @"orderRetailer";
static NSString *const kAnalyticsAttributeOrderServiceType             = @"orderServiceType";
static NSString *const kAnalyticsAttributeOrderDeliveryMethod          = @"orderDeliveryMethod";
static NSString *const kAnalyticsAttributeOrderTotal                   = @"orderTotal";
static NSString *const kAnalyticsAttributeProductRemoved               = @"productRemoved";
static NSString *const kAnalyticsAttributeProductCodeRemoved           = @"productCodeRemoved";
static NSString *const kAnalyticsAttributeFavoritedStoreNumber         = @"favoritedStoreNumber";
static NSString *const kAnalyticsAttributeIsPreservedCart              = @"isPreservedCart";
static NSString *const kAnalyticsAttributeStoreNumber                  = @"storeNumber";
static NSString *const kAnalyticsAttributeSearchLatitude               = @"searchLatitude";
static NSString *const kAnalyticsAttributeSearchLongitude              = @"searchLongitude";
static NSString *const kAnalyticsAttributeSearchZip                    = @"searchZip";
static NSString *const kAnalyticsAttributeSearchRadius                 = @"searchRadius";
static NSString *const kAnalyticsAttributeSearchResultsCount           = @"searchResultsCount";
static NSString *const kAnalyticsAttributeCartItemCount                = @"cartItemCount";

static NSString *const attributeKey = @"attribute";
static NSString *const valueKey = @"value";

//Launch
static NSString *const kSiteDeepLink                                   = @"SiteDeepLink";
static NSString *const kEnableAddMorePhotos                            = @"enableAddMorePhotos";
static NSString *const kMaxImagesMessage                               = @"maxImagesMessage";
static NSString *const kPreRenderedOrder                               = @"preRenderedOrder";
static NSString *const kBrandingInfo                                   = @"brandingInfo";

NS_ASSUME_NONNULL_END

/** The FujifilmSPASDKDelegate protocol defines methods that your delegate object must implement to interact with the Fujifilm SPA SDK interface. The methods of this protocol notify your delegate when the user exits the checkout flow or when an error occurs. See documentation for details on status codes.
 */
@protocol FujifilmSPASDKDelegate

/**
 Required function that is called when the user exited the checkout flow.
 Control is passed back to your application once this delegate method is called.
 @param statusCode - see documentation for list of status codes.
 @param message - see documentation for list of messages.
 */
-(void) fujifilmSPASDKFinishedWithStatus: (int) statusCode andMessage: (NSString*) message;

@optional
/**
 Optional function that is called when an invalid promotion code is passed into the SDK
 @param error - see documentation for list of error codes
 */
-(void) promoCodeDidFailValidationWithError: (int) error;

/**
 Optional function that is called when an analytic event is fired. We provide a way for you to listen to events when users take certain actions. To receive these events, implement the receivedAnalyticsEvent:withAttributes: delegate method.
 @param event - see documentation for list of events
 @param attributes - see documentation for list of attributes
 */
-(void) receivedAnalyticsEvent:(NSString *)event withAttributes:(NSArray *)attributes;

-(NSString *) determineExitMethod: (int) statusCode;

/**
 Optional function (requestForAdditionalPhotos) to implement if you would like to use your own image picker. Our SDK will call this function when a user attempts to add more photos from within our SDK. You can then call the completionHandler to send us the images the user selected.
 
 @param selectedImages - An array of FFImage objects that represents the images the user has in session. This should be referenced in your image picker to display to the user which images are already in their session (show the image as selected). The FFImage object has a uniqueidentifier property that is set to the PHAsset's identifier or the NSURL's path and can be accessed by calling getUniqueIdentifier, [myFFimageObject getUniqueIdentifier]. You can then use this identifier to compare it to the identifiers for the images in your image picker and display to the user the images already in their session.
 @param notDeselectable - An array of FFImage objects that represents the images the user is not allowed to deselect because they are being used in a cart or a product builder. This should be referenced to prevent the user from deselecting images in your image picker. The FFImage object has a uniqueidentifier property that is set to the PHAsset's identifier or the NSURL's path and can be accessed by calling getUniqueIdentifier, [myFFimageObject getUniqueIdentifier]. You can then use this identifier to compare it to the identifiers for the images in your image picker and prevent the user from deselecting the image.
 @param completionHandler - Call this completion handler to send us the images the user selected.
 */
-(void) requestForAdditionalPhotos:(NSArray<FFImage *>*)selectedImages lockedImages:(NSArray<FFImage *>*)notDeselectable withCompletionHandler:(void (^)(NSArray<FFImage *>*))completionHandler;

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

/** initWithApiKey creates a Fujifilm_SPA_SDK_iOS instance that handles all order checkout process.
 
 *Note* : apiKey and environment are required.
 
 - Go to http://www.fujifilmapi.com to register for an apiKey.
 - Ensure you have the right apiKey for the right environment.
 
 @param apiKey(NSString): Fujifilm SPA apiKey you receive when you create your app at http://fujifilmapi.com. This apiKey is environment specific
 @param environment(NSString): Sets the environment to use. The apiKey must match your app’s environment set on http://fujifilmapi.com. Possible values are “preview” or "production".
 @param images(FFImage): An NSArray of FFImage which can be initialized with a PHAsset or NSURL. Images must be jpeg, png, or heic format and smaller than 20MB. A maximum of 100 images can be sent in a given Checkout process. If more than 100 images are sent, only the first 100 will be processed.
 @param userID(NSString): Optional param, send in @"" if you don't use it. This can be used to link a user with an order. MaxLength = 50 alphanumeric characters.
 @param retainUserInfo(BOOL):  Save user information (address, phone number, email) for when the app is used a 2nd time.
 @param promoCode(NSString): Optional parameter to add a promo code to the order. Contact us through http://fujifilmapi.com for usage and support.
 @param launchPage(LaunchPage): The page that the SDK should launch when initialized. Valid values are (kHome, kCart), defaults to kHome
 @param extraOptions: A dictionary with several accepted key/value pairs. All key/value pairs are optional; extraOptions may be empty or nil if no options are desired. See section "Extra Initialization Options" in GitHub documentation for more information.
 */

typedef enum {
    kHome,
    kCart
} LaunchPage;

- (id)initWithApiKey:(NSString *)apiKey environment:(NSString*)environment images:(NSArray *)images userID:(NSString*)userid retainUserInfo:(BOOL)retainUserInfo promoCode:(NSString *)promoCode launchPage:(LaunchPage)initialPage extraOptions:(NSDictionary<NSString *, id>*)extraOptions;

@end

@interface FujifilmSPASDKNavigationController : UINavigationController

@end

@class FFOrder, FFLine, FFPage, FFAsset;

NS_ASSUME_NONNULL_BEGIN

@interface FFOrder : NSObject

@property (nonatomic, retain, readonly, getter=getOrderLines) NSArray<FFLine *> *lines;

+(nullable instancetype)order;
+(nullable instancetype)orderWithLines:(NSArray <FFLine *> *)lines;

-(nullable instancetype)init;
-(nullable instancetype)initWithLines:(NSArray <FFLine *> *)lines;

-(void)addLine:(FFLine *)line;
-(void)removeLine:(FFLine *)line;

@end

@interface FFLine : NSObject

@property (nonatomic, retain, readonly) NSString *productCode;
@property (nonatomic, retain, readonly, getter=getPages) NSArray<FFPage *> *pages;

+(nullable instancetype)lineWithProductCode:(NSString *)productCode;
+(nullable instancetype)lineWithProductCode:(NSString *)productCode pages:(NSArray<FFPage *> *)pages;

-(nullable instancetype)init NS_UNAVAILABLE;
-(nullable instancetype)initWithProductCode:(NSString *)productCode;
-(nullable instancetype)initWithProductCode:(NSString *)productCode pages:(NSArray<FFPage *> *)pages;

-(void)addPage:(FFPage *)page;
-(void)removePage:(FFPage *)page;

@end

@class FFAsset;

@interface FFPage : NSObject

@property (nonatomic, retain, readonly, getter=getPageAssets) NSArray<FFAsset *> *assets;

+(nullable instancetype)page;
+(nullable instancetype)pageWithAssets:(NSArray<FFAsset *> *)assets;

-(nullable instancetype)init;
-(nullable instancetype)initWithAssets:(NSArray<FFAsset *> *)assets;

-(void)addAsset:(FFAsset *)asset;
-(void)removeAsset:(FFAsset *)asset;

@end

typedef NS_ENUM(NSUInteger, FFAssetType) {
    FFAssetTypeImage = 1,
    FFAssetTypeText = 2
};

@interface FFAsset : NSObject

@property (nonatomic, retain, readonly) NSString *hiResImageURL;
@property (nonatomic, assign, readonly) FFAssetType type;

+(nullable instancetype)assetWithHiResImageURL:(NSString *)hiResImageURL;

-(nullable instancetype)init NS_UNAVAILABLE;
-(nullable instancetype)initWithHiResImageURL:(NSString *)hiResImageURL;

@end

@interface FFBrandingInfo : NSObject

@property (nonatomic, retain) UIColor *primaryTextColor;
@property (nonatomic, retain) UIColor *pressedTextColor;
@property (nonatomic, retain) UIColor *primaryBackgroundColor;
@property (nonatomic, retain) UIColor *pressedBackgroundColor;

+(nullable instancetype)brandingWithPrimaryTextColor:(UIColor*)primaryTextColor pressedTextColor:(UIColor*)pressedTextColor primaryBackgroundColor:(UIColor*)primaryBackgroundColor pressedBackgroundColor:(UIColor*)pressedBackgroundColor;
-(nullable instancetype)init NS_UNAVAILABLE;

@end

@interface FFImage: NSObject
- (instancetype) initWithPHAsset: (PHAsset *) phAsset;
- (instancetype) initWithNSURL: (NSURL *) url;
- (instancetype) initWithLocalPath: (NSURL *)url;


/**
 Gets the unique identifier for an FFImage which is set to the PHAsset's identifier or the NSURL's path and can be accessed by calling getUniqueIdentifier
 */
- (NSString *)getUniqueIdentifier;
@end

NS_ASSUME_NONNULL_END
