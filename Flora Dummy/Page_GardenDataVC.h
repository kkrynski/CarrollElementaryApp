//
//  Page_GardenDataVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 12/20/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageVC.h"

@interface Page_GardenDataVC : PageVC<UIPopoverControllerDelegate, UIScrollViewDelegate>
{
    UIImage *gardenImage;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *gardenImageView;

@property(nonatomic, retain) NSArray *touchZones;
@property(nonatomic, retain) NSArray *touchLayers;

@property (nonatomic, strong) UIImage *gardenImage;

@property(nonatomic, retain) UIPopoverController *currentPopover;

@end