//
//  QuickQuizCreationPopOverVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "QuickQuizCreationPopOverVC.h"

@interface QuickQuizCreationPopOverVC ()

@end

@implementation QuickQuizCreationPopOverVC
@synthesize answers, question, correctIndex;
@synthesize questionTextView, image1TextField, image2TextField, image3TextField, correctIndexTextField;
@synthesize updateButton;

///////////// Init Methods ///////////////////////////


-(id)init
{
    if (self = [super init])
    {
        // Initialize
        question = [[NSString alloc] init];
        answers = [[NSMutableArray alloc] initWithObjects:
                   [NSString stringWithFormat:@""],
                   [NSString stringWithFormat:@""],
                   [NSString stringWithFormat:@""],
                   nil];
        correctIndex = [[NSNumber alloc] initWithInt:0];
    }
    return self;
}

///////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *textFields = @[image1TextField, image2TextField, image3TextField];
    
    for (int i = 0; i < answers.count; i++)
    {
        UITextField *field = (UITextField *)[textFields objectAtIndex:i];
        NSString *imageName = (NSString *)[answers objectAtIndex:i];
        
        if (imageName != nil)
        {
            field.text = imageName;
        
        }else
        {
            [answers replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@""]];
            field.text = @"";
        }
    }
    
    if (question != nil)
    {
        questionTextView.text = question;
        
    }else
    {
        question = [[NSString alloc] init];
        questionTextView.text = @"";
    }
    
    if (correctIndex != nil)
    {
        correctIndexTextField.text = correctIndex.stringValue;
        
    }else
    {
        correctIndex = [[NSNumber alloc] initWithInt:0];
        correctIndexTextField.text = @"";
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

-(IBAction)updateQuiz
{
    //Notify the delegate if it exists.
    if (_delegate != nil)
    {
        [self packageContent];
        
        [_delegate returnAnswers:answers andQuestion:question andCorrectIndex:correctIndex];
    }
}

-(void)packageContent
{
    NSArray *textFields = @[image1TextField, image2TextField, image3TextField];
    
    for (int i = 0; i < answers.count; i++)
    {
        UITextField *field = (UITextField *)[textFields objectAtIndex:i];
        
        if (field.text)
        {
            [answers replaceObjectAtIndex:i withObject:field.text];
            
        }else
        {
            [answers replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@""]];

        }
    }

    
    if (questionTextView.text)
    {
        question = questionTextView.text;
        
    }else
    {
        question = [NSString stringWithFormat:@""];
    }
    
    if (correctIndexTextField.text)
    {
        correctIndex = [NSNumber numberWithInt:correctIndexTextField.text.intValue];
    
    }else
    {
        correctIndex = [NSNumber numberWithInt:0];
    }
    
}


@end
