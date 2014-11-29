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
#import "IntroCreationVC.h"
#import "ReadingCreationVC.h"
#import "MathCreationVC.h"
#import "QuickQuizCreationVC.h"
#import "VocabCreationVC.h"

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
    pageTypeArray=[[NSArray alloc] initWithObjects:@"Sandbox", @"Introduction", @"Reading", @"Math", @"Quiz Type 1", @"Quiz Type 2", nil];
    
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

-(IBAction)goToNext
{
    [self hideMaster];

    if ([self.page.pageVCType isEqualToString:(NSString *)[pageTypeArray objectAtIndex:0]])
    {
        // Launch sandbox
        ContentCreationVC *ccVC = [[ContentCreationVC alloc] initWithPageType:self.page.pageVCType];
        
        NSArray *contentArray = (NSArray *)[self.page.variableContentDict objectForKey:@"ContentArray"];
        if (contentArray && contentArray.count > 0)
        {
            [ccVC setContentArray:contentArray.mutableCopy];
        }
        ccVC.delegate = self;
        
        [self.navigationController pushViewController:ccVC animated:YES];
        
    }else if ([self.page.pageVCType isEqualToString:(NSString *)[pageTypeArray objectAtIndex:1]])
    {
        // Launch introdcution
        
        IntroCreationVC *iVC = [[IntroCreationVC alloc] init];
        
        NSString *t = (NSString *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"Text"];
        
        if (t != nil)
        {
            [iVC setText:t];
        }
        
        iVC.delegate = self;

        [self.navigationController pushViewController:iVC animated:YES];

    }else if ([self.page.pageVCType isEqualToString:(NSString *)[pageTypeArray objectAtIndex:2]])
    {
        // Launch reading
        
        ReadingCreationVC *rVC = [[ReadingCreationVC alloc] init];
        
        NSString *t = (NSString *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"Text"];
        
        if (t != nil)
        {
            [rVC setText:t];
        }
        
        rVC.delegate = self;
        
        [self.navigationController pushViewController:rVC animated:YES];
        
    }else if ([self.page.pageVCType isEqualToString:(NSString *)[pageTypeArray objectAtIndex:3]])
    {
        // Launch math
        
        MathCreationVC *mVC = [[MathCreationVC alloc] init];
        
        NSString *e = (NSString *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"Equation"];
        NSString *a = (NSString *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"Answer"];
        
        if (e != nil)
        {
            [mVC setEquation:e];
        }
        if (a != nil)
        {
            [mVC setAnswer:a];
        }
        
        mVC.delegate = self;
        
        [self.navigationController pushViewController:mVC animated:YES];
        
    }else if ([self.page.pageVCType isEqualToString:(NSString *)[pageTypeArray objectAtIndex:4]])
    {
        // Launch quick quiz 1
        
        QuickQuizCreationVC *qqVC = [[QuickQuizCreationVC alloc] init];
        
        NSArray *arr = (NSArray *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"Answers"];
        NSString *q = (NSString *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"Question"];
        NSNumber *n = (NSNumber *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"CorrectIndex"];
        
        if (arr != nil && arr.count > 0)
        {
            [qqVC setAnswers:arr.mutableCopy];
        }
        if (q != nil)
        {
            [qqVC setQuestion:q];
        }
        if (n != nil && arr != nil && arr.count >0 && n.intValue >= 0 && n.intValue < arr.count)
        {
            [qqVC setCorrectIndex:n];
        }
        
        qqVC.delegate = self;
        
        [self.navigationController pushViewController:qqVC animated:YES];
        
    }else if ([self.page.pageVCType isEqualToString:(NSString *)[pageTypeArray objectAtIndex:5]])
    {
        // Launch vocab creation
        
        VocabCreationVC *vcVC = [[VocabCreationVC alloc] init];
        
        NSArray *arr = (NSArray *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"Answers"];
        NSString *q = (NSString *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"Question"];
        NSNumber *n = (NSNumber *)[(NSDictionary *)self.page.variableContentDict objectForKey:@"CorrectIndex"];
        
        if (arr != nil && arr.count > 0)
        {
            [vcVC setAnswers:arr.mutableCopy];
        }
        if (q != nil)
        {
            [vcVC setQuestion:q];
        }
        if (n != nil && arr != nil && arr.count >0 && n.intValue >= 0 && n.intValue < arr.count)
        {
            [vcVC setCorrectIndex:n];
        }
        
        vcVC.delegate = self;
        
        [self.navigationController pushViewController:vcVC animated:YES];
        
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
    if (![self.page.pageVCType isEqualToString:(NSString *)[pageTypeArray objectAtIndex:row]])
    {
        // Reset variable content dictionary if we're changing pages
        self.page.variableContentDict = [[NSDictionary alloc] init];
    }
    
    self.page.pageVCType = (NSString *)[pageTypeArray objectAtIndex:row];

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
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    [tempDict setValue:cArray forKey:@"ContentArray"];
    self.page.variableContentDict = tempDict;
    [self.navigationController popToViewController:self animated:YES];
    
    if (_delegate != nil)
    {
        [_delegate updatePage:self.page];
    }
}

#pragma mark - IntroCreationVC method
// Only for intro
-(void)updateIntroWithText: (NSString *)t
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    [tempDict setValue:t forKey:@"Text"];
    self.page.variableContentDict = tempDict;
    [self.navigationController popToViewController:self animated:YES];
    
    if (_delegate != nil)
    {
        [_delegate updatePage:self.page];
    }
}

#pragma mark - ReadingCreationVC
// Only for reading
-(void)updateReadingVCWithText: (NSString *)t
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    [tempDict setValue:t forKey:@"Text"];
    self.page.variableContentDict = tempDict;
    [self.navigationController popToViewController:self animated:YES];
    
    if (_delegate != nil)
    {
        [_delegate updatePage:self.page];
    }
}

#pragma mark - MathCreationVC
// Only for math
-(void)updateMathVCWithEquation: (NSString *)e andAnswer: (NSString *)a
{
    if (e == nil)
    {
        e = [NSString stringWithFormat:@""];
    }
    if (a == nil)
    {
        a = [NSString stringWithFormat:@""];
    }
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    [tempDict setValue:e forKey:@"Equation"];
    [tempDict setValue:a forKey:@"Answer"];

    self.page.variableContentDict = tempDict;
    [self.navigationController popToViewController:self animated:YES];
    
    if (_delegate != nil)
    {
        [_delegate updatePage:self.page];
    }
}

#pragma mark - QuickQuestionCreationVC

-(void)updateQuizWithAnswers: (NSArray *)array
                 andQuestion: (NSString *)q
             andCorrectIndex: (NSNumber *)n
{
    if (array == nil || array.count == 0)
    {
        array = [[NSMutableArray alloc] initWithObjects:
                   [NSString stringWithFormat:@""],
                   [NSString stringWithFormat:@""],
                   [NSString stringWithFormat:@""],
                   nil];    }
    
    if (q == nil)
    {
        q = [NSString stringWithFormat:@""];
    }
    if (n == nil)
    {
        n = [NSNumber numberWithInt:0];
    }
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    [tempDict setValue:array forKey:@"Answers"];
    [tempDict setValue:q forKey:@"Question"];
    [tempDict setValue:n forKey:@"CorrectIndex"];

    self.page.variableContentDict = tempDict;
    [self.navigationController popToViewController:self animated:YES];
    
    if (_delegate != nil)
    {
        [_delegate updatePage:self.page];
    }
}

#pragma mark - VocabCreationDelegate

-(void)updateVocabWithAnswers: (NSArray *)array
                  andQuestion: (NSString *)q
              andCorrectIndex: (NSNumber *)n
{
    if (array == nil || array.count == 0)
    {
        array = [[NSMutableArray alloc] initWithObjects:
                 [NSString stringWithFormat:@""],
                 [NSString stringWithFormat:@""],
                 [NSString stringWithFormat:@""],
                 [NSString stringWithFormat:@""],
                 [NSString stringWithFormat:@""],
                 nil];
    }
    
    if (q == nil)
    {
        q = [NSString stringWithFormat:@""];
    }
    if (n == nil)
    {
        n = [NSNumber numberWithInt:0];
    }
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    [tempDict setValue:array forKey:@"Answers"];
    [tempDict setValue:q forKey:@"Question"];
    [tempDict setValue:n forKey:@"CorrectIndex"];
    
    self.page.variableContentDict = tempDict;
    [self.navigationController popToViewController:self animated:YES];
    
    if (_delegate != nil)
    {
        [_delegate updatePage:self.page];
    }
}

@end
