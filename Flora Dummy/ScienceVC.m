//
//  ScienceVC.m
//  Flora Dummy
//
//  Created by Zach Nichols on 9/28/13.
//  Copyright (c) 2013 SGSC. All rights reserved.
//

#import "ScienceVC.h"

#import "Page_IntroVC.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ScienceVC ()
{
    // Store the grade number for quicker/easier access
    NSString *gradeNumber;
    
    // Store the font. Later we'll want to hook this up to the
    // NSUserDefaults, so that it can be changed throughout the app.
    UIFont *font;
    
    // Store a float for border width, which will be used to outline
    // tableviews and textviews
    float borderWidth;
    
    // Store colors for quicker/easier access
    UIColor *primaryColor;
    UIColor *secondaryColor;
    UIColor *backgroundColor;
    
    // Load the color scheme if necessary.
    // Consider removing this line.
    NSDictionary *colorSchemeDictionary;
    
    // Store the list of activities for quicker/easier access.
    // List of activities can be pulled from courseDictionary,
    // which will store the loaded data from file.
    NSDictionary *courseDictionary;
    NSArray *activitiesArray;
    
}

@end

@implementation ScienceVC
@synthesize titleLabel, activitiesTableView, notificationTextField;
@synthesize pageManager;

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
    
    // Create our font. Later we'll want to hook this up to the
    // rest of the app for easier change.
    font = [[UIFont alloc]init];
    font = [UIFont fontWithName:@"Marker Felt" size:32.0];
    
    
    // Get data from json file
    NSString *titleDirectory = [[NSBundle mainBundle] resourcePath];
    NSString *fullPath = [titleDirectory stringByAppendingPathComponent:@"Carroll.json"]; // Name of file
    NSData *jsonFile = [NSData dataWithContentsOfFile:fullPath options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonFile options:kNilOptions error:nil];
    
    
    // Get colors data and store it in colorSchemeDictionary
    // The dictionary is currently unused after this point.
    // Consider deleting or modifying
    colorSchemeDictionary = [jsonDictionary valueForKey:@"Colors"];
    
    
    // Get courses/activities
    courseDictionary = [jsonDictionary valueForKey:@"Courses"];
    
    // Store the border width for the tableview.
    borderWidth = 2.0f;
    
    // Create a border for the tableview
    [activitiesTableView.layer setBorderWidth:borderWidth];
    [activitiesTableView.layer setBorderColor:[UIColor whiteColor].CGColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    // Update activities in case any changes have been made, such as homework
    // has passed its due date.
    [self updateActivitiesUsingArray];
    
    
    // Update colors in case user settings have changed
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
    
    notificationTextField.textColor = primaryColor;
    notificationTextField.backgroundColor = [self lighterColorForColor:backgroundColor];
    [self outlineTextInTextView:notificationTextField];
    
    
    activitiesTableView.backgroundColor = [self lighterColorForColor:backgroundColor];
    
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
    [textView.layer setBorderWidth:borderWidth];
    [textView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    // Add some cushion so that the text isn't touching the border
    textView.contentInset = UIEdgeInsetsMake(10.0,0.0,10.0,0.0);
    
    return;
}



// Updates the activities in the table view, which is useful if first
// loading or if the activities have changed.
-(void)updateActivitiesUsingArray
{
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Get grade number
    gradeNumber = [defaults objectForKey:@"gradeNumber"];
    
    // Get activities for this grade and subject
    NSDictionary *gradeDictionary = [courseDictionary valueForKey:gradeNumber];
    
    // Make changes to activities array
    activitiesArray = [gradeDictionary valueForKey:@"Science"];
    
    // Update display
    [activitiesTableView reloadData];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return activitiesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // For taller, more child-friendly cells.
    // Note: the normal height is 44.0
    return 88.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The following chunk of code is pretty standard. It allows you to
    // reuse cells, meaning that instead of making 1000 cells, it reuses
    // cells that have long since left the screen. This saves memory and
    // keeps the app from crashing.
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        // Creates a default style table view cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    // Get the information for the activity at this row
    NSDictionary *activityDict = (NSDictionary *)[activitiesArray objectAtIndex:indexPath.row];
    
    // Update and format the title label, or the primary label in the cell.
    cell.textLabel.text = (NSString *)[activityDict objectForKey:@"Name"];
    cell.textLabel.font = font;
    cell.textLabel.textColor = primaryColor;
    [self outlineTextInLabel:cell.textLabel];
    
    // Update cell colors
    cell.backgroundColor = [self lighterColorForColor:backgroundColor];
    tableView.backgroundColor = [self lighterColorForColor:backgroundColor];
    
    // Changes the color of the lines in between cells.
    [tableView setSeparatorColor:primaryColor];
    
    // Adds an image to the cell for classification purposes.
    //
    // Note: we need to hook this up to several different images
    //       that represent the different types of activities.
    cell.imageView.image = [UIImage imageNamed:@"117-todo.png"];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The following line keeps the cell from staying selected.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get the information for the activity selected
    NSDictionary *activityDict = (NSDictionary *)[activitiesArray objectAtIndex:indexPath.row];
    
    // Create a PageManager for the activity and store it in THIS view controller.
    pageManager = [[PageManager alloc]initWithActivity: activityDict forParentViewController:self];
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */


@end