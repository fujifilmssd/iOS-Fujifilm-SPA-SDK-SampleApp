//
//  LaunchOptionsViewController
//  Fujifilm_SPA_SDK_iOS_DemoApp
//
//  Created by Sam on 4/18/16.
//  Copyright © 2016 ___Fujifilm___. All rights reserved.
//

#import "LaunchOptionsViewController.h"
#import "Fujifilm.SPA.SDK.h"

@implementation LaunchOptionsViewController

@synthesize pageTitles, retailers;

+ (NSArray *) pageTitles
{
    static NSArray *_pageTitles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pageTitles = @[@"Home",
                        @"Product",
                        @"Cart"];
    });
    return _pageTitles;
}

+ (NSArray *) retailers
{
    static NSArray *_retailers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _retailers = @[@"Home Delivery",
                       @"Walmart",
                       @"Sams Club",
                       @"Costco",
                       @"RiteAide",
                       @"Walgreens"];
    });
    return _retailers;
}

-(void)viewDidLoad{
    pageTitles = [[self class] pageTitles];
    
    retailers = [[self class] retailers];
    
    self.pageCell.detailTextLabel.text = self.launchPage;
    self.catalogCell.detailTextLabel.text = self.launchRetailer;
    
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    b.backgroundColor = [UIColor colorWithWhite:0.13 alpha:1];
    [b setTitle:@"Done" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b addTarget:self
          action:@selector(doneButtonPressed)
forControlEvents:UIControlEventTouchUpInside];
    [b setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:b];
}

- (void) doneButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
    //Save only when user taps done!
    [self.delegate didSelectPage: self.launchPage];
    [self.delegate didSelectRetailer: self.launchRetailer];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *options;
    if (indexPath.row == 0) {
        options =  pageTitles;
        
    }
    if (indexPath.row == 1) {
        options = retailers;
    }
    [self showActionSheetForTableCell:[tableView cellForRowAtIndexPath:indexPath] withOptions:options];
}
-(void) showActionSheetForTableCell:(UITableViewCell *)cell withOptions:(NSArray *)options {
    cell.selected = NO;
    if(NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0){
        self.attachmentMenuSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:nil];
        for (NSString *option in options){
            [self.attachmentMenuSheet addButtonWithTitle:option];
        }
        
        //Show cancel button at bottom, intializing it in the constructor causes it to show topmost
        [self.attachmentMenuSheet addButtonWithTitle:@"Cancel"];
        self.attachmentMenuSheet.cancelButtonIndex = [options count];
        
        
        // Show the sheet
        self.attachmentMenuSheet.tag = [cell.textLabel.text isEqualToString:@"Page"] ? 0 : 1;
        [self.attachmentMenuSheet showInView:self.view];
        [self changeTextColorForUIActionSheet: self.attachmentMenuSheet toColor:[UIColor blackColor]];
        
    } else {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIPopoverPresentationController *popPresenter = [actionSheet popoverPresentationController];
        
        popPresenter.sourceView = cell;
        popPresenter.sourceRect = cell.bounds;
        
        UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Cancel button tappped.
            [self dismissViewControllerAnimated:YES completion:^{}];
        }];
        
        [actionSheet addAction:cancelAction];
        
        for (NSString *option in options){
            [actionSheet addAction:[UIAlertAction actionWithTitle:option style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.detailTextLabel.text = option;
                if ([cell.textLabel.text isEqualToString:@"Page"]) {
                    self.launchPage = option;
                } else if ([cell.textLabel.text isEqualToString:@"Catalog"]) {
                    self.launchRetailer = option;
                }
            }]];
        }
        
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
        actionSheet.view.tintColor = [UIColor blackColor];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *option = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (actionSheet.tag == 0) { //Page
            self.pageCell.detailTextLabel.text = option;
            [self.pageCell setNeedsDisplay];
            [self.pageCell setNeedsLayout];
            self.launchPage = option;
        } else if (actionSheet.tag == 1) { //Catalog
            self.catalogCell.detailTextLabel.text = option;
            [self.catalogCell setNeedsDisplay];
            [self.catalogCell setNeedsLayout];
            self.launchRetailer = option;
        }
    }
}

//http://stackoverflow.com/a/19191489
- (void) changeTextColorForUIActionSheet:(UIActionSheet*)actionSheet toColor: (UIColor*) color {
    NSArray *actionSheetButtons = actionSheet.subviews;
    for (int i = 0; [actionSheetButtons count] > i; i++) {
        UIView *view = (UIView*)[actionSheetButtons objectAtIndex:i];
        if([view isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton*)view;
            [btn setTitleColor:color forState:UIControlStateNormal];
            
        }
    }
}
@end
