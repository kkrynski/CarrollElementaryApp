//
//  SettingsVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 9/28/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "SettingsVC.h"

#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SettingsVC ()
{
    // Holds loaded data for colors, specifically HEX code
    NSDictionary *colorSchemeDictionary;
    
    // Stores UIColors for easy/quicker access
    UIColor *primaryColor;
    UIColor *secondaryColor;
    UIColor *backgroundColor;
    
    // Store a float for border width, which will be used to outline
    // tableviews and textviews
    float borderWidth;
}

@end

@implementation SettingsVC
@synthesize titleLabel, gradeLabel, colorLabel;
@synthesize kindergartenButton, firstButton, secondButton, thirdButton, fourthButton, fifthButton, sixthButton;
@synthesize purpleButton, redButton, pinkButton, orangeButton, yellowButton, greenButton, blueButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get contents from json file
    NSString *titleDirectory = [[NSBundle mainBundle] resourcePath];
    NSString *fullPath = [titleDirectory stringByAppendingPathComponent:@"carroll.json"];
    NSData *jsonFile = [NSData dataWithContentsOfFile:fullPath options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonFile options:kNilOptions error:nil];
    
    // Load colors dictionary
    colorSchemeDictionary = [jsonDictionary valueForKey:@"Colors"];
    
    // The following code is meant as an override.
    // Ideally, colors would be loaded from file and applied to these
    // color buttons, but a more dynamic button-saving system is
    // needed. Right now, if we said that the purple button was
    // the color with the name "Purple" from file, it could crash if
    // that color wasn't in the file.
    primaryColor = [UIColor whiteColor];
    
    [purpleButton setTitleColor:primaryColor forState:UIControlStateNormal];
    purpleButton.backgroundColor = [self colorForName:purpleButton.titleLabel.text];
    [self outlineButton:purpleButton];
    
    [redButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:redButton];
    redButton.backgroundColor = [self colorForName:redButton.titleLabel.text];
    
    [pinkButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:pinkButton];
    pinkButton.backgroundColor = [self colorForName:pinkButton.titleLabel.text];
    
    [orangeButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:orangeButton];
    orangeButton.backgroundColor = [self colorForName:orangeButton.titleLabel.text];
    
    [yellowButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:yellowButton];
    yellowButton.backgroundColor = [self darkerColorForColor:[self colorForName:yellowButton.titleLabel.text]];
    
    [greenButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:greenButton];
    greenButton.backgroundColor = [self colorForName:greenButton.titleLabel.text];
  
    [blueButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:blueButton];
    blueButton.backgroundColor = [self colorForName:blueButton.titleLabel.text];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    // Update colors in case the user changed settings
    [self updateColors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark
# pragma mark Color Conversion

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


-(void)updateColors
{
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    // Get the colors from the data, and convert them to UIColor
    primaryColor = [self colorWithHexString:[defaults objectForKey:@"primaryColor"]];
    secondaryColor = [self colorWithHexString:[defaults objectForKey:@"secondaryColor"]];
    backgroundColor = [self colorWithHexString:[defaults objectForKey:@"backgroundColor"]];
    
    
    // Place any overrides here
    primaryColor = [UIColor whiteColor];
    
    
    // Update all subviews or objects on the screen.
    //
    // Note: We need to call functions to outline themselves.
    // Example: [self outlineTextInLabel: ]
    
    titleLabel.textColor = primaryColor;
    [self outlineTextInLabel:titleLabel];
    
    colorLabel.textColor = primaryColor;
    [self outlineTextInLabel:colorLabel];
    
    gradeLabel.textColor = primaryColor;
    [self outlineTextInLabel:gradeLabel];
    
    [kindergartenButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:kindergartenButton];
    kindergartenButton.backgroundColor = secondaryColor;
    
    [firstButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:firstButton];
    firstButton.backgroundColor = secondaryColor;
    
    [secondButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:secondButton];
    secondButton.backgroundColor = secondaryColor;
    
    [thirdButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:thirdButton];
    thirdButton.backgroundColor = secondaryColor;
    
    [fourthButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:fourthButton];
    fourthButton.backgroundColor = secondaryColor;
    
    [fifthButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:fifthButton];
    fifthButton.backgroundColor = secondaryColor;
    
    [sixthButton setTitleColor:primaryColor forState:UIControlStateNormal];
    [self outlineButton:sixthButton];
    sixthButton.backgroundColor = secondaryColor;
    
    // Update background
    self.view.backgroundColor = backgroundColor;
    
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

// This function outlines buttons with a border
-(void)outlineButton: (UIButton *)button
{
    borderWidth = 4.0f;
    
    [self outlineTextInLabel:button.titleLabel];
    
    [[button layer] setBorderWidth:borderWidth];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
}


// If a color button is pressed, get the text of the button. This
// text should be its color. Use the color name to look up the
// appropriate colors, and save them to the user defaults.
//
// Note: look for a better way to do this.
-(IBAction)colorButtonPressed:(id)sender
{
    // Get the button that sent the signal to this function
    UIButton *senderButton = (UIButton *)sender;
    
    // Get the name of the color from the button
    NSString *senderText = senderButton.titleLabel.text;
    
    // Get colorDictionary information for this color
    NSDictionary *colorDictionary = [colorSchemeDictionary objectForKey:senderText];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Save the new color settings
    [defaults setObject:[colorDictionary objectForKey:@"Primary"] forKey:@"primaryColor"];
    [defaults setObject:[colorDictionary objectForKey:@"Secondary"] forKey:@"secondaryColor"];
    [defaults setObject:[colorDictionary objectForKey:@"Background"] forKey:@"backgroundColor"];
    
    [defaults synchronize];

    // Don't forget to update the colors on this page.
    // Other pages should update their colors as they load.
    [self updateColors];

}

// Returns a background color for a color name.
-(UIColor *)colorForName: (NSString *)name
{
    // Get colorDictionary information for this color
    NSDictionary *colorDictionary = [colorSchemeDictionary objectForKey:name];

    // Gets the HEX code for the color
    NSString *colorHEXString = [colorDictionary objectForKey:@"Background"];
    
    // Convert HEX to a UIColor and return it.
    UIColor *color = [self colorWithHexString:colorHEXString];
    
    return color;
}

// If a grade button was pressed, get the grade from the
// button that sent the signal. Then update and save
// settings.
-(IBAction)gradeButtonPressed:(id)sender
{
    // Get the button that called this function
    UIButton *senderButton = (UIButton *)sender;
    
    // Get the grade number based on the button text.
    //
    // Note: it would be more efficient to use tags, or
    //       a more reliable system.
    NSString *senderText = senderButton.titleLabel.text;
    
    // Check if it's kindergarten
    if ([senderText isEqualToString:@"K"])
    {
        senderText = [NSString stringWithFormat:@"Kindergarten"];
    }
    
    // Save the new grade to settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:senderText forKey:@"gradeNumber"];
  
    [defaults synchronize];
 
}

// Returns a string of HEX code given a UIColor
-(NSString *)hexStringForUIColor: (UIColor *)color
{
    CGColorRef colorRef = [color CGColor];
    
    int _countComponents = CGColorGetNumberOfComponents(colorRef);
    
    NSMutableArray *digitArray  = [[NSMutableArray alloc]init];

    if (_countComponents == 4)
    {
        const CGFloat *_components = CGColorGetComponents(colorRef);
        CGFloat red     = _components[0];
        CGFloat green = _components[1];
        CGFloat blue   = _components[2];
        
        NSLog(@"%f,%f,%f",red,green,blue);
        
        //convert to hex string
        int digit1 = (int)red/16;
        [digitArray addObject:[NSNumber numberWithInt:digit1]];

        int digit2 = (int)red%16;
        [digitArray addObject:[NSNumber numberWithInt:digit2]];

        int digit3 = (int)green/16;
        [digitArray addObject:[NSNumber numberWithInt:digit3]];

        int digit4 = (int)green%16;
        [digitArray addObject:[NSNumber numberWithInt:digit4]];
        
        int digit5 = (int)blue/16;
        [digitArray addObject:[NSNumber numberWithInt:digit5]];
        
        int digit6 = (int)blue%16;
        [digitArray addObject:[NSNumber numberWithInt:digit6]];
        
    }
    
    NSString *colorString = [NSString stringWithFormat:@""];

    for (NSNumber *num in digitArray)
    {
        if (num.intValue ==10)
        {
            colorString = [NSString stringWithFormat:@"%@A", colorString];
        }else if (num.intValue ==11)
        {
            colorString = [NSString stringWithFormat:@"%@B", colorString];
        }else if (num.intValue ==12)
        {
            colorString = [NSString stringWithFormat:@"%@C", colorString];
        }else if (num.intValue ==13)
        {
            colorString = [NSString stringWithFormat:@"%@D", colorString];
        }else if (num.intValue ==14)
        {
            colorString = [NSString stringWithFormat:@"%@E", colorString];
        }else if (num.intValue ==15)
        {
            colorString = [NSString stringWithFormat:@"%@F", colorString];
        }else
        {
            colorString = [NSString stringWithFormat:@"%@%i", colorString, num.intValue];
        }
    }
    
    return colorString;
}


@end
