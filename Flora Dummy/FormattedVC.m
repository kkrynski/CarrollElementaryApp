//
//  FormattedVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 2/15/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"

#import "FloraDummy-Swift.h"

@interface FormattedVC ()

@end

@implementation FormattedVC
@synthesize colorSchemeDictionary, primaryColor, secondaryColor, backgroundColor;
@synthesize font;

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*
    // Double check to make sure orientation is correct.
    // iOS 7 introduced a bug where sometimes the VC
    // doesn't know which orientation it's supposed to be.
    // Thus, in landscape, it creates a landscape VC but
    // any reference to its frame will result in portrait
    // values.
    CGRect r = self.view.bounds;
    
    if (r.size.height > r.size.width)
    {
        float w = r.size.width;
        r.size.width = r.size.height;
        r.size.height = w;
    }
    
    self.view.bounds = r;
     */// -- Not an issue in iOS 8 *Michael*
    
    // Initialize font
    font = [UIFont fontWithName:@"Marker Felt" size:32.0];
    
    [self updateColors];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Update colors in case the user changed settings
    [self updateColors];
}

/// Updates colors in view
///
/// Subclasses should override this method to perform custom color updating
///
/// \note You must call [superview updateColors] first in the overridden method
-(void) updateColors
{
    //Get Colors
    primaryColor = [Definitions colorWithHexString:[[NSUserDefaults standardUserDefaults] objectForKey:@"primaryColor"]];
    secondaryColor = [Definitions colorWithHexString:[[NSUserDefaults standardUserDefaults] objectForKey:@"secondaryColor"]];
    
    //Override
    //TODO: Fix this later
    primaryColor =[UIColor whiteColor];
    secondaryColor = [Definitions lighterColorForColor:[Definitions colorWithHexString:[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"]]];

    [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction) animations:^
    {
        self.view.backgroundColor = [Definitions colorWithHexString:[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"]];
    } completion:nil];
    
}


@end
