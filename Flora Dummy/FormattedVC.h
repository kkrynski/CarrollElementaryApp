//
//  FormattedVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 2/15/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CESDatabaseActivity;

@interface FormattedVC : UIViewController <CESDatabaseActivity>
{
    //Holds loaded data for colors, specifically HEX code
    NSDictionary *colorSchemeDictionary;
    
    //Text Color
    UIColor *primaryColor;
    
    //Text Background Color
    UIColor *secondaryColor;
    
    UIColor *backgroundColor DEPRECATED_ATTRIBUTE;
    
    //Store font to be used
    UIFont *font;
    
    BOOL isPresented;
}

@property(nonatomic, retain) NSDictionary *colorSchemeDictionary;
@property(nonatomic, retain) UIColor *primaryColor;
@property(nonatomic, retain) UIColor *secondaryColor;
@property(nonatomic, retain) UIColor *backgroundColor DEPRECATED_ATTRIBUTE;
@property(nonatomic, retain) UIFont *font;

/// These functions are used to convert a hex number (in string format) to a UIColor
///
/// These functions are just to condense code
///
/// \note This method is deprecated, please use the \b Definitions method instead
- (UIColor *) colorWithHexString:(NSString *)hexString DEPRECATED_MSG_ATTRIBUTE("Please use the Definitions method instead");

/// These functions are used to convert a hex number (in string format) to a UIColor
///
/// These functions are just to condense code
- (CGFloat) colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length DEPRECATED_ATTRIBUTE;

/// Updates colors in view
///
/// Subclasses should override this method to perform custom color updating
///
/// \note You must call [super updateColors] first in the overridden method
-(void)updateColors;

/// This function outlines the text in a label, meaning it gives the text a border
///
/// This presents a more "bubble" letter effect, which is more pleasant for elementary schoolers
///
/// \note This method is deprecated, please use the \b Definitions method instead
-(void)outlineTextInLabel: (UILabel *)label DEPRECATED_MSG_ATTRIBUTE("Please use the Definitions method instead");

/// This function outlines the text in a text view, meaning it gives the text a border
///
/// This presents a more "bubble" letter effect, which is more pleasant for elementary schoolers
///
/// \note This is a little more complicated than a label
///
/// \note This method is deprecated, please use the \b Definitions method instead
-(void)outlineTextInTextView: (UITextView *)textView DEPRECATED_MSG_ATTRIBUTE("Please use the Definitions method instead");

/// This function outlines buttons with a border
///
/// \note This method is deprecated, please use the \b Definitions method instead
-(void)outlineButton: (UIButton *)button DEPRECATED_MSG_ATTRIBUTE("Please use the Definitions method instead");

/// This function outlines views with a border
///
/// \note This method is deprecated, please use the \b Definitions method instead
-(void)outlineView: (UIView *)view DEPRECATED_MSG_ATTRIBUTE("Please use the Definitions method instead");

/// Creates a slightly lighter color for a given color
///
/// \note This method is deprecated, please use the \b Definitions method instead
- (UIColor *)lighterColorForColor:(UIColor *)c DEPRECATED_MSG_ATTRIBUTE("Please use the Definitions method instead");

/// Creates a slightly darker color for a given color
///
/// \note This method is deprecated, please use the \b Definitions method instead
- (UIColor *)darkerColorForColor:(UIColor *)c DEPRECATED_MSG_ATTRIBUTE("Please use the Definitions method instead");

@end
