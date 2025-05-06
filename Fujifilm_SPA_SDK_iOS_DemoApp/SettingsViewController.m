//
//  SettingsViewController.m
//  Fujifilm_SPA_SDK_iOS_DemoApp
//
//  Created by Sam on 4/1/16.
//  Copyright © 2016 ___Fujifilm___. All rights reserved.
//

#import "SettingsViewController.h"
#import  <Fujifilm_SPA_SDK_iOS/Fujifilm.SPA.SDK.h>

@interface SettingsViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pickerTextView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger dynamicSection;

@end

@implementation SettingsViewController

static NSArray<NSString *> *pickerDisplayNames;
static NSArray<FFLine *> *pickerDefaultLines;

static NSString * const kSPAPrerenderedImageRootPath = @"https://stage.webservices.fujifilmesys.com/imagebank/spaprerendered";

-(void) viewDidLoad {
    [self.tableView setDelegate:self];
    [self.apiKey setDelegate:self];
    [self.userID setDelegate:self];
    [self.promoCode setDelegate:self];
    [self.deepLink setDelegate:self];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    [_versionNumber setText:version];
    [self setupProductPickerView];
    self.preRenderedLines = [NSMutableArray new];
    self.dynamicSection = 2;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.delegate = self;
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

-(NSNumber *) getEnableAddMorePhotos {
    return [NSNumber numberWithBool:[self.enableAddMorePhotos isOn]];
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


#pragma mark - Class Initialization

+(void) initialize {
    pickerDisplayNames = @[@"4x8 Greeting Card", @"5x7 Greeting Card", @"5x7 Stationery Card", @"8x8 Photobook"];
    [SettingsViewController createLinesForPreRenderedProducts];
}

+(void)createLinesForPreRenderedProducts {
    FFLine *photobookLine = [SettingsViewController createPhotobookLine];
    FFLine *stationeryCardLine = [SettingsViewController createStationeryCardLine];
    FFLine *gc4x8Line = [SettingsViewController create4x8GreetingCardLine];
    FFLine *gc5x7Line = [SettingsViewController create5x7GreetingCardLine];
    
    pickerDefaultLines = @[gc4x8Line, gc5x7Line, stationeryCardLine, photobookLine];
}

+(FFLine *)createPhotobookLine {
    FFLine *line = [FFLine lineWithProductCode:@"PRGift;5212"];
    for (int i = 0; i < 12; i++) {
        FFPage *linePage = [FFPage page];
        NSString *imageUrl = [NSString stringWithFormat:@"%@/photobook/page%d.jpg", kSPAPrerenderedImageRootPath, i];
        FFAsset *asset = [FFAsset assetWithHiResImageURL:imageUrl];
        [linePage addAsset:asset];
        [line addPage:linePage];
    }
    return line;
}

+(FFLine *)createStationeryCardLine {
    FFLine *line = [FFLine lineWithProductCode:@"PRGift;4121"];
    for (int i = 0; i < 2; i++) {
        FFPage *linePage = [FFPage page];
        NSString *imageUrl = [NSString stringWithFormat:@"%@/sc/page%d.jpg", kSPAPrerenderedImageRootPath, i];
        FFAsset *asset = [FFAsset assetWithHiResImageURL:imageUrl];
        [linePage addAsset:asset];
        [line addPage:linePage];
    }
    return line;
}

+(FFLine *)create4x8GreetingCardLine {
    NSString *imageUrl =[NSString stringWithFormat:@"%@/4x8gc/page0.jpg", kSPAPrerenderedImageRootPath];
    FFAsset *asset = [FFAsset assetWithHiResImageURL:imageUrl];
    FFPage *linePage = [FFPage pageWithAssets:[NSArray arrayWithObject:asset]];
    return [FFLine lineWithProductCode:@"PRGC;823" pages:[NSArray arrayWithObject:linePage]];
}

+(FFLine *)create5x7GreetingCardLine {
    NSString *imageUrl =[NSString stringWithFormat:@"%@/5x7gc/page0.jpg", kSPAPrerenderedImageRootPath];
    FFAsset *asset = [FFAsset assetWithHiResImageURL:imageUrl];
    FFPage *linePage = [FFPage pageWithAssets:[NSArray arrayWithObject:asset]];
    return [FFLine lineWithProductCode:@"PRGC;830" pages:[NSArray arrayWithObject:linePage]];
}

#pragma mark - Choose Product Picker Methods

-(void) setupProductPickerView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(productPickerCancelTapped)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(productPickerDoneTapped)];
    
    toolBar.items = @[barButtonCancel, flex, barButtonDone];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolBar.frame.size.height, screenWidth, 200)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, toolBar.frame.size.height + self.pickerView.frame.size.height)];
    inputView.backgroundColor = [UIColor clearColor];
    [inputView addSubview:self.pickerView];
    [inputView addSubview:toolBar];
    
    self.pickerTextView.inputView = inputView;
}

-(void) productPickerDoneTapped {
    NSInteger selectedIdx = [self.pickerView selectedRowInComponent:0];
    [self.preRenderedLines addObject:[pickerDefaultLines objectAtIndex:selectedIdx]];
    [self.pickerTextView resignFirstResponder];
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:self.preRenderedLines.count inSection:self.dynamicSection]; // NOT -1 for the row
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

-(void) productPickerCancelTapped {
    [self.pickerTextView resignFirstResponder];
}

-(IBAction)selectProductTapped:(id)sender {
    [self.pickerTextView becomeFirstResponder];
}

#pragma mark - UITableViewDelegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dynamicSection && indexPath.row > 0) {
        return YES;
    }
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dynamicSection && indexPath.row > 0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.preRenderedLines removeObjectAtIndex:indexPath.row-1];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == self.dynamicSection) {
        return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == self.dynamicSection && indexPath.row > 0) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.dynamicSection) {
        return [self.preRenderedLines count] + 1;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == self.dynamicSection && row > 0) {
        // make dynamic row's cell
        static NSString *CellIdentifier = @"Dynamic Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        FFLine *line = [self.preRenderedLines objectAtIndex:row - 1];
        NSInteger lineIdx = [pickerDefaultLines indexOfObject:line];
        NSString *lineDisplayName = [pickerDisplayNames objectAtIndex:lineIdx];
        cell.textLabel.text = lineDisplayName;
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}



#pragma mark - UIPickerViewDelegate methods

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerDisplayNames objectAtIndex:row];
}

#pragma mark - UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}
@end

