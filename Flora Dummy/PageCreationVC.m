//
//  PageCreationVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/22/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "PageCreationVC.h"

#import "Page.h"
#import "ContentCreationVC.h"

@interface PageCreationVC ()
{
    NSArray *pageTypeArray;
}
@end

@implementation PageCreationVC
@synthesize pagePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //One column array example
    pageTypeArray=[[NSArray alloc] initWithObjects:@"Sandbox", @"Introduction", @"Reading", @"Math", @"Quiz Type 1", @"Quiz Type 2", @"Spelling Question", nil];
    
    if (self.page == nil)
    {
        self.page = [[Page alloc] init];

    }
    self.page.pageVCType = [pageTypeArray objectAtIndex:0];
    
    pagePicker.showsSelectionIndicator = TRUE;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPage:(Page *)newPage
{
    if (_page != newPage)
    {
        _page = newPage;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.page)
    {
        [pagePicker reloadAllComponents];
        
        for (int i = 0; i < pageTypeArray.count; i++)
        {
            if ([(NSString *)[pageTypeArray objectAtIndex:i] isEqualToString:self.page.pageVCType])
            {
                [pagePicker selectRow:i inComponent:0 animated:YES];
                
                return;
            }
        }
        
        [pagePicker selectRow:0 inComponent:0 animated:YES];
    }
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [self hideMaster];
    
    if ([segue.identifier isEqualToString:@"GoToContentEditor"])
    {
        ContentCreationVC *contentCreationVC = segue.destinationViewController;
        
        if (self.page.contentArray && self.page.contentArray.count > 0)
        {
            contentCreationVC.contentArray = self.page.contentArray.mutableCopy;
        }
        
        contentCreationVC.pageType = self.page.pageVCType;
        contentCreationVC.delegate = self;
    }
 }

-(void)viewWillAppear:(BOOL)animated
{
    [self unhideMaster];
}
 


#pragma mark - UIPickerView stuff

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return pageTypeArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [pageTypeArray objectAtIndex:row];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.page.pageVCType = [pageTypeArray objectAtIndex:row];
    self.page.pageVCType = [pageTypeArray objectAtIndex:row];
    
}




-(IBAction)hideMaster
{
    _isHidden = YES;
    [self.splitViewController.view setNeedsLayout];
    self.splitViewController.delegate = nil;
    self.splitViewController.delegate = self;
    
    [self.splitViewController willRotateToInterfaceOrientation:[UIApplication    sharedApplication].statusBarOrientation duration:0];
    
}

-(IBAction)unhideMaster
{
    _isHidden = NO;
    [self.splitViewController.view setNeedsLayout];
    self.splitViewController.delegate = nil;
    self.splitViewController.delegate = self;
    
    [self.splitViewController willRotateToInterfaceOrientation:[UIApplication    sharedApplication].statusBarOrientation duration:0];

}

#pragma mark - Split view

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return self.isHidden;
}


#pragma mark - ContentPickerDelegate method
-(void)updateContentArray:(NSArray *)cArray
{
    self.page.contentArray = cArray;
    [self.navigationController popToViewController:self animated:YES];
    
    if (_delegate != nil)
    {
        [_delegate updatePage:self.page];
    }
}


@end
