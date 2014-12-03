//
//  QuickQuizCreationVC.m
//  FloraDummy
//
//  Created by Zachary Nichols on 11/26/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "QuickQuizCreationVC.h"

@interface QuickQuizCreationVC ()
{

}
@end

@implementation QuickQuizCreationVC
@synthesize questionLabel, option1Button, option2Button, option3Button;
@synthesize question, answers, correctIndex;

-(id)init
{
    if (self = [super init])
    {
        // Initialize
        answers = [[NSMutableArray alloc] initWithObjects:
                     [NSString stringWithFormat:@"page4_apple"],
                     [NSString stringWithFormat:@"page4_hamburger"],
                     [NSString stringWithFormat:@"page4_sun"],
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
                   [NSString stringWithFormat:@"page4_apple"],
                   [NSString stringWithFormat:@"page4_hamburger"],
                   [NSString stringWithFormat:@"page4_sun"],
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
                   [NSString stringWithFormat:@"page4_apple"],
                   [NSString stringWithFormat:@"page4_hamburger"],
                   [NSString stringWithFormat:@"page4_sun"],
                   nil];
    }
    
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(presentPopOver:)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItems = @[editButton, saveButton];
    
    [self populateView];
    
}

-(IBAction)presentPopOver: (id)sender
{
    if (_quizPicker == nil)
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
    }
}


-(IBAction)save
{
    //Notify the delegate if it exists.
    if (_delegate != nil)
    {
        //text = textView.text;
        [_delegate updateQuizWithAnswers:answers andQuestion:question andCorrectIndex:correctIndex];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateColors
{
    [super updateColors];
    
    [self outlineTextInLabel:questionLabel];
    questionLabel.textColor = primaryColor;
    questionLabel.backgroundColor = secondaryColor;
    questionLabel.backgroundColor = secondaryColor;
    
}

-(void)populateView
{
    for (UIView *v in self.view.subviews)
    {
        [v removeFromSuperview];
    }
    
    // Question label
    // Note: dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 122, 480, 44)];

    questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                              122 + 20,
                                                              self.view.frame.size.width - 40,
                                                              44 + 20)];
    
    questionLabel.text = question;
    questionLabel.textAlignment = NSTextAlignmentCenter;
    questionLabel.font = self.font;
    
    questionLabel.textColor = primaryColor;
    questionLabel.backgroundColor = secondaryColor;
    
    [self.view addSubview:questionLabel];
    
    
    // Buttons
    
    // Option 1
    option1Button = [[UIButton alloc] initWithFrame:CGRectMake(questionLabel.frame.origin.x,
                                                               questionLabel.frame.origin.y + questionLabel.frame.size.height + 20,
                                                               (self.view.frame.size.width - 80) / 3,
                                                               (self.view.frame.size.width - 80) / 3)];
    
    //option1Button.backgroundColor = secondaryColor;
    [option1Button setBackgroundImage:[UIImage imageNamed:(NSString *)[answers objectAtIndex:0]]
                             forState:UIControlStateNormal];
    option1Button.tag = 0;
    
    [option1Button addTarget:self
                      action:@selector(optionSelected:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self outlineButton:option1Button];
    [self.view addSubview:option1Button];
    
    
    
    // Option 2
    option2Button = [[UIButton alloc] initWithFrame:CGRectMake(option1Button.frame.origin.x + option1Button.frame.size.width + 20,
                                                               option1Button.frame.origin.y,
                                                               option1Button.frame.size.width,
                                                               option1Button.frame.size.height)];
    //option1Button.backgroundColor = secondaryColor;
    [option2Button setBackgroundImage:[UIImage imageNamed:(NSString *)[answers objectAtIndex:1]]
                             forState:UIControlStateNormal];
    option2Button.tag = 1;
    
    [option2Button addTarget:self
                      action:@selector(optionSelected:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self outlineButton:option2Button];
    [self.view addSubview:option2Button];
    
    
    
    // Option 3
    option3Button = [[UIButton alloc] initWithFrame:CGRectMake(option2Button.frame.origin.x + option2Button.frame.size.width + 20,
                                                               option2Button.frame.origin.y,
                                                               option2Button.frame.size.width,
                                                               option2Button.frame.size.height)];
    
    //option1Button.backgroundColor = secondaryColor;
    [option3Button setBackgroundImage:[UIImage imageNamed:(NSString *)[answers objectAtIndex:2]]
                             forState:UIControlStateNormal];
    option3Button.tag = 2;
    
    [option3Button addTarget:self
                      action:@selector(optionSelected:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self outlineButton:option3Button];
    [self.view addSubview:option3Button];
    
    
}

-(void)updateView
{
    questionLabel.text = question;
    
    [option1Button setBackgroundImage:[UIImage imageNamed:(NSString *)[answers objectAtIndex:0]]
                             forState:UIControlStateNormal];
    [option2Button setBackgroundImage:[UIImage imageNamed:(NSString *)[answers objectAtIndex:1]]
                             forState:UIControlStateNormal];
    [option3Button setBackgroundImage:[UIImage imageNamed:(NSString *)[answers objectAtIndex:2]]
                             forState:UIControlStateNormal];

}

-(void)optionSelected:(id)sender
{
    //UIButton *senderButton = (UIButton *)sender;
    
    
}


# pragma mark - PopOverDelegate

-(void)returnAnswers: (NSArray *)array andQuestion: (NSString *)q andCorrectIndex: (NSNumber *)n
{
    answers = array.mutableCopy;
    question = q;
    correctIndex = n;
    
    [self updateView];
    
    [_quizPickerPopOver dismissPopoverAnimated:YES];
    _quizPickerPopOver = nil;
    _quizPicker = nil;
}

@end
