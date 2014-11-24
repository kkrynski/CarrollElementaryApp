//
//  ContentCreationVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/23/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "ContentCreationVC.h"

@interface ContentCreationVC ()
{
    UIView *selectedContent;
}
@end

@implementation ContentCreationVC
@synthesize contentArray, pageType;

-(id)init
{
    if (self = [super init])
    {
        // Initialize
        contentArray = [[NSMutableArray alloc] init];
        pageType = [[NSString alloc] init];
    }
    return self;
}

-(id)initWithPageType: (NSString *)pT
{
    if (self = [super init])
    {
        // Initialize
        contentArray = [[NSMutableArray alloc] init];
        pageType = [[NSString alloc] initWithString:pT];
    }
    return self;
}

-(id)initWithContent: (NSArray *)cArray andPageType: (NSString *)pT
{
    if (self = [super init])
    {
        // Initialize
        contentArray = [[NSMutableArray alloc] initWithArray:cArray];
        pageType = [[NSString alloc] initWithString:pT];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedContent = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];

    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItems = @[addButton, saveButton];
    
    if(!contentArray)
    {
        contentArray = [[NSMutableArray alloc] init];
    
    }else
    {
        int i = 0;
        for (Content *content in contentArray)
        {
            [self addContent:content withTag:i];
            i += 1;
        }
    }
}


- (void)singleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView: self.view];
    
    NSLog(@"Tap at (%.0f, %.0f)", touchPoint.x, touchPoint.y);
    
    for (UIView *subview in self.view.subviews)
    {
        float x = subview.frame.origin.x;
        float y = subview.frame.origin.y;
        float w = subview.frame.size.width;
        float h = subview.frame.size.height;
        
        if (((touchPoint.x >= x) && (touchPoint.x <= (x + w))) &&
            ((touchPoint.y >= y) && (touchPoint.y <= (y + h))))
        {
            [self presentPopoverAtRect:CGRectMake(x, y, w, h)];
            
            selectedContent = subview;
            
            return;
        }
        
    }
}

-(void)presentPopoverAtRect: (CGRect)rect
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Edit", @"Move", @"Copy", nil];
    actionSheet.tag = 100;
    [actionSheet showFromRect:rect inView:self.view animated:YES];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100)
    {
        NSLog(@"Action sheet 1.");
        
        switch (buttonIndex)
        {
            case 0:
            {
                // Deletion
                NSLog(@"Delete");
                //[self showDeleteConfirmation:nil];
                
                [self deleteObject];
                break;
            
            }case 1:
            {
                // Edit
                NSLog(@"Edit");
                
                [self editObject];
                
                break;
                
            }case 2:
            {
                // Move
                NSLog(@"Move");
                
                break;
                
            }case 3:
            {
                // Copy
                NSLog(@"Copy");
                
                break;
                
            }default:
            {
                break;
            }
                
        }
    }
    else if (actionSheet.tag == 200)
    {
        NSLog(@"Action sheet 2. (Deletion confirm)");
        
        switch (buttonIndex)
        {
            case 0:
            {
                // Deletion
                NSLog(@"Delete for real");
                int tag = selectedContent.tag;
                [selectedContent removeFromSuperview];
                
                for (UIView *subview in self.view.subviews)
                {
                    if (subview.tag > tag)
                    {
                        subview.tag = subview.tag - 1;
                    }
                }
                
                [contentArray removeObjectAtIndex:tag];
                
                break;
                
            }default:
            {
                break;
            }
                
        }
    }
    
    
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

/*- (IBAction)showDeleteConfirmation:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete this content?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:nil];
    
    actionSheet.tag = 200;
    [actionSheet showFromRect:selectedContent.frame inView:self.view animated:YES];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)insertNewObject:(id)sender
{
    if (_contentPicker == nil) {
        //Create the ColorPickerViewController.
        _contentPicker = [[ContentPopOverVC alloc] initWithPageType:pageType];
        
        //Set this VC as the delegate.
        _contentPicker.delegate = self;

    }
    
    if (_contentPickerPopOver == nil) {
        //The color picker popover is not showing. Show it.
        _contentPickerPopOver = [[UIPopoverController alloc] initWithContentViewController:_contentPicker];
        _contentPickerPopOver.popoverContentSize = CGSizeMake(self.contentPicker.view.frame.size.width, self.contentPicker.view.frame.size.height);
        [_contentPickerPopOver presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [_contentPickerPopOver dismissPopoverAnimated:YES];
        _contentPickerPopOver = nil;
    }
}

-(IBAction)save
{
    //Notify the delegate if it exists.
    if (_delegate != nil)
    {
        [_delegate updateContentArray:contentArray];
    }
}

-(void)editObject
{
    int tag = selectedContent.tag;
    Content *currentContent = (Content *)[contentArray objectAtIndex:tag];
    
    if (_contentPicker == nil)
    {
        //Create the ColorPickerViewController.
        _contentPicker = [[ContentPopOverVC alloc] initWithContent:currentContent andPageType:pageType];
        
        //Set this VC as the delegate.
        _contentPicker.delegate = self;
        
    }else
    {
        _contentPicker.content = currentContent;
    }
    
    if (_contentPickerPopOver == nil) {
        //The color picker popover is not showing. Show it.
        _contentPickerPopOver = [[UIPopoverController alloc] initWithContentViewController:_contentPicker];
        _contentPickerPopOver.popoverContentSize = CGSizeMake(self.contentPicker.view.frame.size.width, self.contentPicker.view.frame.size.height);
        //[_contentPickerPopOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItems.firstObject permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [_contentPickerPopOver presentPopoverFromRect:selectedContent.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [_contentPickerPopOver dismissPopoverAnimated:YES];
        _contentPickerPopOver = nil;
    }
}

-(void)deleteObject
{
    // Deletion
    NSLog(@"Delete for real");
    int tag = selectedContent.tag;
    [selectedContent removeFromSuperview];
    
    for (UIView *subview in self.view.subviews)
    {
        if (subview.tag > tag)
        {
            subview.tag = subview.tag - 1;
        }
    }
    
    [contentArray removeObjectAtIndex:tag];

}


#pragma mark - ContentPickerDelegate method
-(void)updatedContent:(Content *)c
{
    [contentArray addObject:c];
    [_contentPickerPopOver dismissPopoverAnimated:YES];
    _contentPickerPopOver = nil;
    _contentPicker = nil;
    
    [self addContent:c withTag:contentArray.count-1];
}

-(void)addContent: (Content *)c withTag: (int)tag
{
    if ([c.type isEqualToString:@"Image"])
    {
        UIImageView *newImageView = [[UIImageView alloc] initWithFrame:[c getFrame]];
        newImageView.backgroundColor = [UIColor redColor];
        if([UIImage imageNamed:[c.variableContent objectForKey:@"Image"]])
        {
            newImageView.image = [UIImage imageNamed:[c.variableContent objectForKey:@"Image"]];
        
        }else
        {
            newImageView.image = [UIImage imageNamed:@"169-8ball"];
        }
        
        newImageView.tag = tag;
        [self.view addSubview:newImageView];
        
    }else if ([c.type isEqualToString:@"Text"])
    {
        UITextView *newTextView = [[UITextView alloc] initWithFrame:[c getFrame]];
        newTextView.backgroundColor = [UIColor yellowColor];
        if([c.variableContent objectForKey:@"Text"])
        {
            newTextView.text = (NSString *)[c.variableContent objectForKey:@"Text"];
            
        }else
        {
            newTextView.text = @"No text";
        }
        
        newTextView.tag = tag;
        newTextView.userInteractionEnabled = NO;
        [self.view addSubview:newTextView];

    }
}


@end
