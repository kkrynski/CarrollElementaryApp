//
//  ContentPopOverVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/23/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "ContentPopOverVC.h"

#import "ContentPopOverVC.h"

@interface ContentPopOverVC ()
{
    NSArray *contentTypeArray;
    NSDictionary *contentLabelsDict;
    
    int mode;
}
@end

@implementation ContentPopOverVC
@synthesize content;
@synthesize contentTypePicker;
@synthesize xField, yField, widthField, heightField;
@synthesize variableContentLabel, variableContentTextView;
@synthesize finishButton;
@synthesize pageType;

///////////// Init Methods ///////////////////////////

-(id)initWithMode: (int)m
{
    if (self = [super init])
    {
        // Initialize
        content = [[Content alloc] init];
        mode = m;
    }
    return self;
}

-(id)initWithPageType: (NSString *)pT andMode: (int)m
{
    if (self = [super init])
    {
        // Initialize
        content = [[Content alloc] init];
        pageType = [[NSString alloc] initWithString:pT];
        mode = m;

    }
    return self;
}

-(id)initWithContent: (Content *)c andMode: (int)m
{
    if (self = [super init])
    {
        // Initialize
        content = [[Content alloc] init];
        content = c;
        mode = m;

    }
    return self;
}

-(id)initWithContent: (Content *)c andPageType: (NSString *)pT andMode: (int)m
{
    if (self = [super init])
    {
        // Initialize
        content = [[Content alloc] init];
        content = c;
        pageType = [[NSString alloc] initWithString:pT];
        mode = m;

    }
    return self;
}

///////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];

    contentTypeArray = [[NSArray alloc] initWithObjects:@"Image", @"Text", nil];
    contentLabelsDict = [[NSDictionary alloc] initWithObjects:@[@[@"Image"], @[@"Text"]] forKeys:contentTypeArray];
    if (!content.type || [content.type isEqualToString:@""])
    {
        content.type = (NSString *)[contentTypeArray objectAtIndex:0];
    }
    for (int i = 0; i < contentTypeArray.count; i++)
    {
        if ([(NSString *)[contentTypeArray objectAtIndex:i] isEqualToString:content.type])
        {
            [self.contentTypePicker selectRow:i inComponent:0 animated:NO];
        }
    }
    
    // Fill in text fields
    if ([content arrayForBounds])
    {
        NSArray *bounds = [content arrayForBounds];
        NSArray *fields = @[xField, yField, widthField, heightField];
        for (int i = 0; i < fields.count; i++)
        {
            UITextField *field = (UITextField *)[fields objectAtIndex:i];
            
            if (![bounds objectAtIndex:i] || [[bounds objectAtIndex:i] isEqualToNumber:[NSNumber numberWithFloat:0.0]])
            {
                field.text = @"";
                field.placeholder = @"0";
            
            }else
            {
                field.text = [NSString stringWithFormat:@"%.0f", [(NSNumber *)[bounds objectAtIndex:i] floatValue]];
                field.placeholder = @"";


            }
        }
    }
    
    if (content.variableContent)
    {
        variableContentTextView.text = (NSString *)[content.variableContent objectForKey:content.type];
    }
    
    if (mode == 0)
    {
        // insertion mode
        
        [finishButton setTitle:@"Add Content" forState:UIControlStateNormal];
        
        [finishButton addTarget:self action:@selector(addContent) forControlEvents:UIControlEventTouchUpInside];
        self.contentTypePicker.userInteractionEnabled = YES;

    }else if (mode == 1)
    {
        // edit mode
        
        [finishButton setTitle:@"Make Changes" forState:UIControlStateNormal];
        
        [finishButton addTarget:self action:@selector(editContent) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentTypePicker.userInteractionEnabled = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIPickerView stuff

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return contentTypeArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [contentTypeArray objectAtIndex:row];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.content.type = [contentTypeArray objectAtIndex:row];
    
    variableContentTextView.hidden = NO;

    if([self.content.type isEqualToString:@"Image"])
    {
        variableContentLabel.text = @"Image";
        
    }else if([self.content.type isEqualToString:@"Text"])
    {
        variableContentLabel.text = @"Text";
        
    }else
    {
        variableContentLabel.text = @"";
        variableContentTextView.hidden = YES;
    }
    
}

-(void)addContent
{
    //Notify the delegate if it exists.
    if (_delegate != nil)
    {
        [self packageContent];
        
        [_delegate insertContent:content];
    }
}

-(void)editContent
{
    //Notify the delegate if it exists.
    if (_delegate != nil)
    {
        [self packageContent];
        
        [_delegate updateContent:content];
    }
}

-(void)packageContent
{
    // Content type sould already be taken care of
    
    // Get frame data
    NSNumber *x = [NSNumber numberWithFloat:xField.text.floatValue];
    NSNumber *y = [NSNumber numberWithFloat:yField.text.floatValue];
    NSNumber *width = [NSNumber numberWithFloat:widthField.text.floatValue];
    NSNumber *height = [NSNumber numberWithFloat:heightField.text.floatValue];
    [content setFrame:@[x, y, width, height]];
    
    // Get variable content data
    NSLog(@"Setting value: %@\tfor key: %@", (NSString *)variableContentTextView.text, (NSString *)[(NSArray *)[contentLabelsDict objectForKey:content.type] objectAtIndex:0]);
    NSDictionary *variableContentDict = [[NSDictionary alloc] initWithObjects:@[(NSString *)variableContentTextView.text] forKeys:@[[(NSArray *)[contentLabelsDict objectForKey:content.type] objectAtIndex:0]]];
    content.variableContent = variableContentDict;
    
}


@end
