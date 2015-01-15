//
//  FormattedVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 2/15/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"
#import "FloraDummy-Swift.h"

@interface FormattedVC () <CESDatabaseActivity> @end

@implementation FormattedVC

@synthesize colorSchemeDictionary, primaryColor, secondaryColor, font, backgroundColor;

- (void) viewDidLoad
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Update colors in case the user changed settings
    [self updateColors];
}

// These functions are used to convert a hex number (in string format) to a UIColor.
// These functions are just to condense code.
- (UIColor *) colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    alpha = 1.0f;
    red   = [self colorComponentFrom: colorString start: 0 length: 2];
    green = [self colorComponentFrom: colorString start: 2 length: 2];
    blue  = [self colorComponentFrom: colorString start: 4 length: 2];
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

- (CGFloat) colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

/// Updates colors in view
///
/// Subclasses should override this method to perform custom color updating
///
/// \note You must call [super updateColors] first in the overridden method
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

// This function outlines the text in a label, meaning it gives
// the text a border. This presents a more "bubble" letter effect,
// which is more pleasant for elementary schoolers.
-(void)outlineTextInLabel: (UILabel *)label
{
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.1f, 0.1f);
    label.layer.shadowOpacity = 1.0f;
    label.layer.shadowRadius = 1.0f;
    
    return;
}

// This function outlines the text in a text view, meaning it gives
// the text a border. This presents a more "bubble" letter effect,
// which is more pleasant for elementary schoolers.
//
// Note: this is a little more complicated than a label
-(void)outlineTextInTextView: (UITextView *)textView
{
    // Store the text real quick
    NSString *text = textView.text;
    
    // Format paragraphs
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 10.0;
    paragraphStyle.firstLineHeadIndent = 10.0;
    paragraphStyle.tailIndent = -10.0;
    
    
    NSDictionary *attrsDictionary = @{NSFontAttributeName: font,
                                      NSParagraphStyleAttributeName: paragraphStyle};
    textView.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attrsDictionary];
    
    
    // Change the color of the text
    textView.textColor = primaryColor;
    
    // Create a shadow on the texts
    textView.textInputView.layer.shadowColor = [[UIColor blackColor] CGColor];
    textView.textInputView.layer.shadowOffset = CGSizeMake(0.1f, 0.1f);
    textView.textInputView.layer.shadowOpacity = 1.0f;
    textView.textInputView.layer.shadowRadius = 1.0f;
    
    // Create a border around the text view
    float borderWidth = 2.0f;
    [textView.layer setBorderWidth:borderWidth];
    [textView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    // Add some cushion so that the text isn't touching the border
    textView.contentInset = UIEdgeInsetsMake(10.0,0.0,10.0,0.0);
    
    return;
}

// This function outlines buttons with a border
-(void)outlineButton: (UIButton *)button
{
    float borderWidth = 4.0f;
    
    [self outlineTextInLabel:button.titleLabel];
    
    [[button layer] setBorderWidth:borderWidth];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
}

// THis function outlines views with a border
-(void)outlineView: (UIView *)view
{
    float borderWidth = 2.0f;
    
    [[view layer] setBorderWidth:borderWidth];
    [[view layer] setBorderColor:[UIColor whiteColor].CGColor];
}

// Creates a slightly lighter color for a given color
- (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.1, 1.0)
                               green:MIN(g + 0.1, 1.0)
                                blue:MIN(b + 0.1, 1.0)
                               alpha:a];
    return nil;
}

// Creates a slightly darker color for a given color
- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}

@end
