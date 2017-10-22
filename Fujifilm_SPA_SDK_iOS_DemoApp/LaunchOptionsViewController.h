//
//  LaunchOptionsViewController
//  Fujifilm_SPA_SDK_iOS_DemoApp
//
//  Created by Sam on 4/18/16.
//  Copyright © 2016 ___Fujifilm___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LaunchOptionsViewController;

@protocol LaunchOptionsDelegate <NSObject>
- (void) didSelectPage:(NSString *)page;
- (void) didSelectRetailer:(NSString *) retailer;
@end

@interface LaunchOptionsViewController : UITableViewController<UIActionSheetDelegate, UITableViewDelegate>{}
@property (nonatomic, weak) id <LaunchOptionsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableViewCell *pageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *catalogCell;
@property (retain, nonatomic) NSString *launchPage;
@property (retain, nonatomic) NSString *launchRetailer;
@property (strong, nonatomic) UIActionSheet *attachmentMenuSheet;
@property (nonatomic, retain) NSArray *pageTitles;
@property (nonatomic, retain) NSArray *retailers;

+ (NSArray *) pageTitles;
+ (NSArray *) retailers;
@end
