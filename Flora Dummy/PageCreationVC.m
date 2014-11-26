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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //One column array example
    pageTypeArray=[[NSArray alloc] initWithObjects:@"Sandbox", @"Introduction", @"Reading", @"Math", @"Quiz Type 1", @"Quiz Type 2", @"Spelling Question", nil];
    
    if (self.page == nil)
    {
        self.page = [[Page alloc] init];
        self.page.pageVCType = (NSString *)[pageTypeArray firstObject];
        if (_delegate != nil)
        {
            [_delegate updatePage:self.page];
        }
    }
    
    [self pickerView:pagePicker selectRowForString:self.page.pageVCType];

    
    
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
        
        if (self.page.pageVCType == nil || [self.page.pageVCType isEqualToString:@""])
        {
            self.page.pageVCType = (NSString *)[pageTypeArray firstObject];
            
            if (_delegate != nil)
            {
                [_delegate updatePage:self.page];
            }
        }
        
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
        
        [self pickerView:pagePicker selectRowForString:self.page.pageVCType];
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
        
        // If sandbox, it should have a content array
        NSArray *contentArray = (NSArray *)[self.page.variableContentDict objectForKey:@"ContentArray"];
        if (contentArray && contentArray.count > 0)
        {
            contentCreationVC.contentArray = contentArray.mutableCopy;

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

    if (_delegate != nil)
    {
        [_delegate updatePage:self.page];
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView selectRowForString: (NSString *)string
{
    for (int i = 0; i < pageTypeArray.count; i++)
    {
        if ([string isEqualToString:(NSString *)[pageTypeArray objectAtIndex:i]])
        {
            [pickerView selectRow:i inComponent:0 animated:YES];
            
            return;
        }
    }
    
    [pickerView selectRow:0 inComponent:0 animated:YES];

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
// Only for sandbox
-(void)updateContentArray:(NSArray *)cArray
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:self.page.variableContentDict];
    
    [tempDict setValue:cArray forKey:@"ContentArray"];
    self.page.variableContentDict = tempDict;
    [self.navigationController popToViewController:self animated:YES];
    
    if (_delegate != nil)
    {
        [_delegate updatePage:self.page];
    }
}


@end
