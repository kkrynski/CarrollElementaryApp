//
//  FormattedVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 2/15/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol CESDatabaseActivity;

@interface FormattedVC : UIViewController /*<CESDatabaseActivity>*/
{
    //Holds loaded data for colors, specifically HEX code
    NSDictionary *colorSchemeDictionary;
    
    //Text Color
    UIColor *primaryColor;
    
    //Text Background Color
    UIColor *secondaryColor;
    
    //Store font to be used
    UIFont *font;
}

@property(nonatomic, retain) NSDictionary *colorSchemeDictionary;
@property(nonatomic, retain) UIColor *primaryColor;
@property(nonatomic, retain) UIColor *secondaryColor;
@property(nonatomic, retain) UIFont *font;

-(void)updateColors;

@end
