//
//  HomeVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 9/28/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "HomeVC.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HomeVC ()
{
    // Store colors
    UIColor *primaryColor;
    UIColor *secondaryColor;
    UIColor *backgroundColor;
    
    // Store a float for border width, which will be used to outline
    // tableviews and textviews
    float borderWidth;
}
@end

@implementation HomeVC
@synthesize titleLabel, subTitleLabel, homeImageView;

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
    // Do any additional setup after loading the view from its nib.

    /*homeImageView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"HOME1.gif"],
                                     [UIImage imageNamed:@"HOME2.gif"],
                                     [UIImage imageNamed:@"HOME2.gif"],
                                     [UIImage imageNamed:@"HOME2.gif"],
                                     [UIImage imageNamed:@"HOME3.gif"],
                                     [UIImage imageNamed:@"HOME3.gif"],
                                     [UIImage imageNamed:@"HOME3.gif"],
                                     [UIImage imageNamed:@"HOME4.gif"],
                                     [UIImage imageNamed:@"HOME4.gif"],
                                     [UIImage imageNamed:@"HOME4.gif"],
                                     [UIImage imageNamed:@"HOME3.gif"],
                                     [UIImage imageNamed:@"HOME3.gif"],
                                     [UIImage imageNamed:@"HOME3.gif"],
                                     [UIImage imageNamed:@"HOME2.gif"],
                                     [UIImage imageNamed:@"HOME2.gif"],
                                     [UIImage imageNamed:@"HOME2.gif"],
                                     nil];
    
    
    homeImageView.animationDuration = 0.8;
    homeImageView.animationRepeatCount = 0;
    [homeImageView startAnimating];*/
    homeImageView.image = [UIImage imageNamed:@"HOME1.gif"];
}

-(void)viewWillAppear:(BOOL)animated
{
    // When the view appears, we want to update the colors.
    // This means that if the colors were changed from pink to blue,
    // those changes should be implemented now.
    
    [self updateColors];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This function updates the colors for all elements on the screen.
// Keep in mind that this function will change with varying screens,
// as other screens will have different objects.
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
    
    subTitleLabel.textColor = primaryColor;
    [self outlineTextInLabel:subTitleLabel];

    
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

@end
