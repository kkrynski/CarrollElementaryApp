//
//  FormattedVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 2/15/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormattedVC : UIViewController
{
    // Holds loaded data for colors, specifically HEX code
    NSDictionary *colorSchemeDictionary;
    
    // Stores UIColors for easy/quicker access
    UIColor *primaryColor;
    UIColor *secondaryColor;
    UIColor *backgroundColor;
    
    // Store font to be used
    UIFont *font;
}

@property(nonatomic, retain) NSDictionary *colorSchemeDictionary;
@property(nonatomic, retain) UIColor *primaryColor;
@property(nonatomic, retain) UIColor *secondaryColor;
@property(nonatomic, retain) UIColor *backgroundColor;
@property(nonatomic, retain) UIFont *font;

// These functions are used to convert a hex number (in string format) to a UIColor.
// These functions are just to condense code.
- (UIColor *) colorWithHexString:(NSString *)hexString;

- (CGFloat) colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length;

// Updates colors in view
// Subclasses should call this method and then perform additional actions
-(void)updateColors;

// This function outlines the text in a label, meaning it gives
// the text a border. This presents a more "bubble" letter effect,
// which is more pleasant for elementary schoolers.
-(void)outlineTextInLabel: (UILabel *)label;

// This function outlines the text in a text view, meaning it gives
// the text a border. This presents a more "bubble" letter effect,
// which is more pleasant for elementary schoolers.
//
// Note: this is a little more complicated than a label
-(void)outlineTextInTextView: (UITextView *)textView;

// This function outlines buttons with a border
-(void)outlineButton: (UIButton *)button;

// THis function outlines views with a border
-(void)outlineView: (UIView *)view;

// Creates a slightly lighter color for a given color
- (UIColor *)lighterColorForColor:(UIColor *)c;

// Creates a slightly darker color for a given color
- (UIColor *)darkerColorForColor:(UIColor *)c;

@end
