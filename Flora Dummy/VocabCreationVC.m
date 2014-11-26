//
//  VocabCreationVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "VocabCreationVC.h"

@interface VocabCreationVC ()

@end

@implementation VocabCreationVC
@synthesize questionTextView, answerFields;
@synthesize question, answers, correctIndex;
@synthesize correctIndexSegmentedControl;

-(id)init
{
    if (self = [super init])
    {
        // Initialize
        answers = [[NSMutableArray alloc] initWithObjects:
                   [NSString stringWithFormat:@"A"],
                   [NSString stringWithFormat:@"B"],
                   [NSString stringWithFormat:@"C"],
                   [NSString stringWithFormat:@"D"],
                   [NSString stringWithFormat:@"E"],
                   nil];
        question = [[NSString alloc] initWithFormat:@""];
        correctIndex = [[NSNumber alloc] initWithInt:0];
        
    }
    return self;
}

-(id)initWithImages: (NSArray *)array
{
    if (self = [super init])
    {
        // Initialize
        answers = [[NSMutableArray alloc] initWithArray:array];
        question = [[NSString alloc] initWithFormat:@""];
        correctIndex = [[NSNumber alloc] initWithInt:0];
    }
    return self;
}

-(id)initWithImages: (NSArray *)array andCorrectIndex: (NSNumber *)n
{
    if (self = [super init])
    {
        // Initialize
        answers = [[NSMutableArray alloc] initWithArray:array];
        question = [[NSString alloc] initWithFormat:@""];
        correctIndex = n;
    }
    return self;
}

-(id)initWithQuestion: (NSString *)q
{
    if (self = [super init])
    {
        // Initialize
        answers = [[NSMutableArray alloc] initWithObjects:
                   [NSString stringWithFormat:@"A"],
                   [NSString stringWithFormat:@"B"],
                   [NSString stringWithFormat:@"C"],
                   [NSString stringWithFormat:@"D"],
                   [NSString stringWithFormat:@"E"],
                   nil];
        question = [[NSString alloc] initWithString:question];
        correctIndex = [[NSNumber alloc] initWithInt:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (answers == nil || answers.count <= 0)
    {
        answers = [[NSMutableArray alloc] initWithObjects:
                   [NSString stringWithFormat:@"A"],
                   [NSString stringWithFormat:@"B"],
                   [NSString stringWithFormat:@"C"],
                   [NSString stringWithFormat:@"D"],
                   [NSString stringWithFormat:@"E"],
                   nil];
    }
    
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItems = @[saveButton];
    
    [self populateView];
    
}

-(IBAction)presentPopOver: (id)sender
{
    /*if (_quizPicker == nil)
    {
        //Create the ColorPickerViewController.
        _quizPicker = [[QuickQuizCreationPopOverVC alloc] init];
        
        if (answers != nil && answers.count > 0)
        {
            [_quizPicker setAnswers:answers];
        }
        
        if (question != nil)
        {
            [_quizPicker setQuestion:question];
        }
        
        if (correctIndex != nil)
        {
            [_quizPicker setCorrectIndex:correctIndex];
        }
        
        //Set this VC as the delegate.
        _quizPicker.delegate = self;
        
    }
    
    if (_quizPickerPopOver == nil)
    {
        //The color picker popover is not showing. Show it.
        _quizPickerPopOver = [[UIPopoverController alloc] initWithContentViewController:_quizPicker];
        _quizPickerPopOver.popoverContentSize = CGSizeMake(self.quizPicker.view.frame.size.width, self.quizPicker.view.frame.size.height);
        [_quizPickerPopOver presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else
    {
        //The color picker popover is showing. Hide it.
        [_quizPickerPopOver dismissPopoverAnimated:YES];
        _quizPickerPopOver = nil;
    }*/
}


-(IBAction)save
{
    if (questionTextView.text)
    {
        question = questionTextView.text;
        
    }else
    {
        question = [NSString stringWithFormat:@""];
    }
    
    NSMutableArray *newAnswers = [[NSMutableArray alloc] init];
    for (UITextField *field in answerFields)
    {
        if (field.text)
        {
            [newAnswers addObject:field.text];
        
        }else
        {
            [newAnswers addObject:[NSString stringWithFormat:@""]];
        }
    }
    
    answers = newAnswers;
    
    correctIndex = [NSNumber numberWithInt: correctIndexSegmentedControl.selectedSegmentIndex];
    
    //Notify the delegate if it exists.
    if (_delegate != nil)
    {
        //text = textView.text;
        [_delegate updateVocabWithAnswers:answers andQuestion:question andCorrectIndex:correctIndex];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateColors
{
    [super updateColors];
    
    if (questionTextView.text)
    {
        [self outlineTextInTextView:questionTextView];

    }
    
    questionTextView.textColor = primaryColor;
    questionTextView.backgroundColor = secondaryColor;
    questionTextView.backgroundColor = secondaryColor;
    
}

-(void)populateView
{
    answerFields = [[NSMutableArray alloc] init];
    
    for (UIView *v in self.view.subviews)
    {
        [v removeFromSuperview];
    }
    
    // Question label
    // Note: dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 122, 480, 44)];
    
    questionTextView = [[UITextView alloc] initWithFrame:CGRectMake(20,
                                                              122 + 20,
                                                              (self.view.frame.size.width - 60)/2,
                                                              44 + 20)];
    
    if (question != nil)
    {
        questionTextView.text = question;

    }else
    {
        questionTextView.text = @"";
    }
    
    //questionTextView.textAlignment = NSTextAlignmentCenter;
    questionTextView.font = self.font;
    
    questionTextView.textColor = primaryColor;
    questionTextView.backgroundColor = secondaryColor;
    
    [self.view addSubview:questionTextView];
    
    if (questionTextView.text)
    {
        [self outlineTextInTextView:questionTextView];
        
    }
    
    // For correct index
    correctIndexSegmentedControl = [[UISegmentedControl alloc] initWithFrame:
                                    CGRectMake(questionTextView.frame.origin.x + 0.25 * questionTextView.frame.size.width,
                                               questionTextView.frame.origin.y +
                                               2 * (questionTextView.frame.size.height + 20),
                                               questionTextView.frame.size.width / 2,
                                               44)];
    
    // Text fields (5)
    float y = questionTextView.frame.origin.y;
    
    for (int i = 0; i < answers.count; i++)
    {
        UITextField *textField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(questionTextView.frame.origin.x + questionTextView.frame.size.width + 20,
                                             y,
                                             questionTextView.frame.size.width,
                                             questionTextView.frame.size.height)];
        
        y += questionTextView.frame.size.height + 20;
        
        if ([answers objectAtIndex:i])
        {
            textField.text = (NSString *)[answers objectAtIndex:i];
        
        }else
        {
            textField.text = @"";
        }
        
        textField.tag = i;
        textField.backgroundColor = secondaryColor;

        [answerFields addObject:textField];
        [self.view addSubview:textField];
        
        [correctIndexSegmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%i", i] atIndex:i animated:NO];

    }
    
    if (correctIndex && correctIndex.intValue < correctIndexSegmentedControl.numberOfSegments)
    {
        [correctIndexSegmentedControl setSelectedSegmentIndex:correctIndex.intValue];
    
    }else
    {
        [correctIndexSegmentedControl setSelectedSegmentIndex:0];

    }
    
    [self.view addSubview:correctIndexSegmentedControl];
    
}

-(void)updateView
{
    if (question != nil)
    {
        questionTextView.text = question;

    }
    
    for (UITextField *field in answerFields)
    {
        if ([answers objectAtIndex:field.tag])
        {
            field.text = (NSString *)[answers objectAtIndex:field.tag];

        }
    }
    
}

/*# pragma mark - PopOverDelegate

-(void)returnAnswers: (NSArray *)array andQuestion: (NSString *)q andCorrectIndex: (NSNumber *)n
{
    answers = array.mutableCopy;
    question = q;
    correctIndex = n;
    
    [self updateView];
    
    [_quizPickerPopOver dismissPopoverAnimated:YES];
    _quizPickerPopOver = nil;
    //_quizPicker = nil;
}*/

@end
