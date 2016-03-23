//
//  AGIPCGridCell.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import "AGIPCGridCell.h"
#import "AGIPCGridItem.h"

#import "AGImagePickerController.h"
#import "AGImagePickerController+Constants.h"

@implementation AGIPCGridCell

#pragma mark - Properties

@synthesize items;

- (void)setItems:(NSArray *)theItems
{
    @synchronized (self)
    {
        if (items != theItems)
        {
                        items = theItems;
            
            for (UIView *view in [self.contentView subviews])
            {
                [view removeFromSuperview];
            }
            
            for (AGIPCGridItem *gridItem in items)
            {
                [self addSubview:gridItem];
            }
        }

//        if (items != theItems)
//        {
//            for (UIView *view in [self subviews]) 
//            {		
//                [view removeFromSuperview];
//            }
//            
//            [items release];
//            items = [theItems retain];
//        }
        
        //if (items != theItems)
       // {
//            for (UIView *view in [self subviews])
//            {
//                [view removeFromSuperview];
//            }
          //  [items release];
          //  items = [theItems retain];
//            
//            for (AGIPCGridItem *view in [self subviews])
//            {
//                if ([view isKindOfClass:[AGIPCGridItem class]]){
//                    [view removeFromSuperview];
//                }
//            }
//            for (UIView *view in [self.contentView subviews])
//            {
//                [view removeFromSuperview];
//            }
//            for (AGIPCGridItem *gridItem in items)
//            {
//                [self addSubview:gridItem];
//            }

       
            
      //  }
//        if (items != theItems)
//        {
//            for (AGIPCGridItem *view in [self subviews])
//            {
//                if ([view isKindOfClass:[AGIPCGridItem class]]){
//                    [view removeFromSuperview];
//                }
//            }
//            [items release];
//            items = [theItems retain];
//        }
//

    }
}

- (NSArray *)items
{
    NSArray *array = nil;
    
    @synchronized (self)
    {
        array = items;
    }
    
    return array;
}

#pragma mark - Object Lifecycle


- (id)initWithItems:(NSArray *)theItems reuseIdentifier:(NSString *)theIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:theIdentifier];
    if(self)
    {    
		self.items = theItems;
        
        UIView *emptyView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView = emptyView;
	}
	
	return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{   
    CGRect frame = [AGImagePickerController itemRect];
    CGFloat leftMargin = frame.origin.x;
    
	for (AGIPCGridItem *gridItem in self.items)
    {	
		[gridItem setFrame:frame];
        UITapGestureRecognizer *selectionGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:gridItem action:@selector(tap)];
        selectionGestureRecognizer.numberOfTapsRequired = 1;
		[gridItem addGestureRecognizer:selectionGestureRecognizer];
        
		[self addSubview:gridItem];
		
		frame.origin.x = frame.origin.x + frame.size.width + leftMargin;
	}
}

@end
