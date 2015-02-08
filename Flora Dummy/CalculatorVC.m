//
//  CalculatorVC.m
//  FloraDummy
//
//  Created by Riley Shaw on 11/1/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "CalculatorVC.h"
#import "FloraDummy-Swift.h"

@interface CalculatorVC ()

@end

@implementation CalculatorVC
@synthesize calLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
NSMutableArray *expression;
int operator;
bool trigisClicked = false;
bool expoisClicked= false;
bool constisClicked= false;
bool extraisClicked= false;
UIView *trigView;
UIView *expoView;
UIView *constView;
UIView *extraView;
int state = 0;
NSString *curNum = @"";
- (void)viewDidLoad {
    [super viewDidLoad];
    [calLabel setAdjustsFontSizeToFitWidth:YES];
    [calLabel setMinimumScaleFactor:0.5];
    expression = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)command:(NSString *)val{
    NSLog(@"%d",state);
    if(state == -1){
        curNum = @"";
        [expression removeAllObjects];
        calLabel.text = @"";
        [expression addObject:(val)];
        curNum = [NSString stringWithFormat:@"%@%@",curNum,val];
        calLabel.text = [NSString stringWithFormat:@"%@%@",calLabel.text , val];
        state = 0;
    }else if(state == 0){
        NSInteger index = [expression indexOfObject:curNum];
        curNum = [NSString stringWithFormat:@"%@%@",curNum,val];
        if (index != NSNotFound)
            [expression replaceObjectAtIndex:index withObject:curNum]; // Need to fix if num - -num
        else
        {
            [expression addObject:val];
            curNum = val;
        }
        calLabel.text = [NSString stringWithFormat:@"%@%@",calLabel.text , val];
    }else if (state == 1){
        [expression addObject:(val)];
        calLabel.text = [NSString stringWithFormat:@"%@%@",calLabel.text , val];
        curNum = @"";
        state = 0;
    }
}
- (NSString *)calculate:(NSMutableArray *)express{
    @try {
    if(state == 0){
        NSLog(@"Express array: %@", express);
        NSUInteger openParenIndex = [express indexOfObject:@"("];
         if([express count] > 1){
        int closeParenIndex = 0;
        int parencount = 0;
        if(openParenIndex != NSNotFound){
            for(int i = (int)openParenIndex; i < [express count]; i++){
                if([express[i] isEqualToString:@"("]){
                    parencount++;
                    if (parencount == 1)
                        openParenIndex = i;
                }else if([express[i] isEqualToString:@")"]){
                    parencount--;
                    if(parencount == 0 ){
                        closeParenIndex = i;
                         NSLog(@"close minus open: %d%lu", closeParenIndex,(unsigned long)openParenIndex);
                        if(closeParenIndex-openParenIndex>2){
                        
                        NSArray *insideParenArray = [express subarrayWithRange:NSMakeRange(openParenIndex + 1, (closeParenIndex - openParenIndex) - 1)];
                        NSLog(@"Inside Parentheses Array: %@", insideParenArray);
                        
                        NSString *answerInsideParens = [self calculate:[NSMutableArray arrayWithArray:insideParenArray]];
                        
                        [express removeObjectsInRange:NSMakeRange(openParenIndex, (closeParenIndex - openParenIndex) + 1)];
                        NSLog(@"Answer: %@", answerInsideParens);
                        [express insertObject:answerInsideParens atIndex:openParenIndex];
                        
                        i -= NSMakeRange(openParenIndex, (closeParenIndex - openParenIndex) + 1).length;
                        i++;
                        }else if(closeParenIndex-openParenIndex == 2){
                              NSString *answerInsideParens = express[closeParenIndex-1];
                            [express removeObjectsInRange:NSMakeRange(openParenIndex, (closeParenIndex - openParenIndex) + 1)];
                           
                            [express insertObject:answerInsideParens atIndex:openParenIndex];
                            
                            i -= NSMakeRange(openParenIndex, (closeParenIndex - openParenIndex) + 1).length;
                            i++;

                        }else{
                            [express removeObjectsInRange:NSMakeRange(openParenIndex, (closeParenIndex - openParenIndex) + 1)];
                            i -= NSMakeRange(openParenIndex, (closeParenIndex - openParenIndex) + 1).length;
                            i++;
                        }
                        NSLog(@"%@", express);
                    }
                }
                if(i == [express count]-1 && parencount == 1){
                    [express addObject:(@")")];
                    [self calculate:express];
                }
            }
        }
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"√"]){
                NSString *num1 = express[i+1];
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(sqrt(num1.doubleValue))]];
                [express removeObjectAtIndex:i+1];
                i--;
            }
        }
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"!"]){
                NSString *num1 = express[i-1];
                 NSLog(@"%@", express);
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(tgamma(num1.doubleValue + 1.0))]];
                  NSLog(@"%@", express);
                [express removeObjectAtIndex:i-1];
                  NSLog(@"%@", express);
                i--;
            }
        }
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"e"]){
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",M_E]];
                i--;
            }
        }
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"π"]){
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",M_PI]];
                i--;
            }
        }
        
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"ln"]){
                NSString *num1 = express[i+1];
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(log(num1.doubleValue))]];
                [express removeObjectAtIndex:i+1];
                i--;
            }
        }
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"log"]){
                NSString *num1 = express[i+1];
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(log10(num1.doubleValue))]];
                [express removeObjectAtIndex:i+1];
                i--;
            }
        }

        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"sin"]){
                NSString *num1 = express[i+1];
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(sin(num1.doubleValue))]];
                [express removeObjectAtIndex:i+1];
                i--;
            }
        }
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"cos"]){
                NSString *num1 = express[i+1];
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(cos(num1.doubleValue))]];
                [express removeObjectAtIndex:i+1];
                i--;
            }
        }
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"tan"]){
                NSString *num1 = express[i+1];
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(tan(num1.doubleValue))]];
                [express removeObjectAtIndex:i+1];
                i--;
            }
        }
        
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"arcsin"]){
                NSString *num1 = express[i+1];
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(180 / M_PI*(asin(num1.doubleValue)))]];
                [express removeObjectAtIndex:i+1];
                i--;
            }
        }
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"arccos"]){
                NSString *num1 = express[i+1];
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(180 / M_PI*(acos(num1.doubleValue)))]];
                [express removeObjectAtIndex:i+1];
                i--;
            }
        }
        for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"arctan"]){
                NSString *num1 = express[i+1];
                [express replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",(180 / M_PI*(atan(num1.doubleValue)))]];
                [express removeObjectAtIndex:i+1];
                i--;
            }
        }
            for(int i = 0; i < [express count]; i++){
                if([express[i] isEqualToString:@"^"]){
                    NSString *num1 = express[i-1];
                    NSString *num2 = express[i+1];
                    [express replaceObjectAtIndex:i-1 withObject:[NSString stringWithFormat:@"%f",(pow(num1.doubleValue,num2.doubleValue))]];
                    [express removeObjectAtIndex:i];
                    [express removeObjectAtIndex:i];
                    i--;
                }
            }
            
            for(int i = 0; i < [express count]; i++){
                if([express[i] isEqualToString:@"*"]){
                    NSString *num1 = express[i-1];
                    NSString *num2 = express[i+1];
                    [express replaceObjectAtIndex:i-1 withObject:[NSString stringWithFormat:@"%f",(num1.doubleValue*num2.doubleValue)]];
                    [express removeObjectAtIndex:i];
                    [express removeObjectAtIndex:i];
                    i--;
                } else if([express[i] isEqualToString:@"/"]){
                    NSString *num1 = express[i-1];
                    NSString *num2 = express[i+1];
                    [express replaceObjectAtIndex:i-1 withObject:[NSString stringWithFormat:@"%f",(num1.doubleValue/num2.doubleValue)]];
                    [express removeObjectAtIndex:i];
                    [express removeObjectAtIndex:i];
                    i--;
                }
            }
            for(int i = 0; i < [express count]; i++){
                if([express[i] isEqualToString:@"*"]){
                    NSString *num1 = express[i-1];
                    NSString *num2 = express[i+1];
                    [express replaceObjectAtIndex:i-1 withObject:[NSString stringWithFormat:@"%f",(num1.doubleValue*num2.doubleValue)]];
                    [express removeObjectAtIndex:i];
                    [express removeObjectAtIndex:i];
                    i--;
                } else if([express[i] isEqualToString:@"/"]){
                    NSString *num1 = express[i-1];
                    NSString *num2 = express[i+1];
                    [express replaceObjectAtIndex:i-1 withObject:[NSString stringWithFormat:@"%f",(num1.doubleValue/num2.doubleValue)]];
                    [express removeObjectAtIndex:i];
                    [express removeObjectAtIndex:i];
                    i--;
                }
            }
            
            for(int i = 0; i < [express count]; i++){
                if([express[i] isEqualToString:@"+"]){
                    NSString *num1 = express[i-1];
                    NSString *num2 = express[i+1];
                    [express replaceObjectAtIndex:i-1 withObject:[NSString stringWithFormat:@"%f",(num1.doubleValue+num2.doubleValue)]];
                    [express removeObjectAtIndex:i];
                    [express removeObjectAtIndex:i];
                    i--;
                } else if([express[i] isEqualToString:@"-"]){
                    NSString *num1 = express[i-1];
                    NSString *num2 = express[i+1];
                    [express replaceObjectAtIndex:i-1 withObject:[NSString stringWithFormat:@"%f",(num1.doubleValue-num2.doubleValue)]];
                    [express removeObjectAtIndex:i];
                    [express removeObjectAtIndex:i];
                    i--;
                }
            }
        } else{
             [expression removeAllObjects];
            [expression addObject:@"0"];
        }
       
        curNum = express[0];
        if(curNum.doubleValue < 1.0){
            calLabel.text = [express[0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0."]];
            calLabel.text = [NSString stringWithFormat:@"%@",calLabel.text];
        }else{
            calLabel.text = [express[0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0."]];
        }
        
    }
    }
        @catch (NSException *exception) {
            curNum = @"";
            [expression removeAllObjects];
            calLabel.text = @"";
        }
        @finally {
            
        }
    return curNum;
}
- (IBAction)zeroBut:(id)sender {
    [self command:@"0"];
}
- (IBAction)oneBut:(id)sender {
    [self command:@"1"];
}
- (IBAction)twoBut:(id)sender {
    [self command:@"2"];
}
- (IBAction)threeBut:(id)sender {
    [self command:@"3"];
}
- (IBAction)fourBut:(id)sender {
    [self command:@"4"];
}
- (IBAction)fiveBut:(id)sender {
    [self command:@"5"];
}
- (IBAction)sixBut:(id)sender {
    [self command:@"6"];
}
- (IBAction)sevenBut:(id)sender {
    [self command:@"7"];
}
- (IBAction)eightBut:(id)sender {
    [self command:@"8"];
}
- (IBAction)nineBut:(id)sender {
    [self command:@"9"];
}
- (IBAction)addBut:(id)sender {
    state = 1;
    [self command:@"+"];
}
- (IBAction)subBut:(id)sender {
    state = 1;
    [self command:@"-"];
}
- (IBAction)mulBut:(id)sender {
    state = 1;
    [self command:@"*"];
}
- (IBAction)divBut:(id)sender {
    state = 1;
    [self command:@"/"];
}
- (IBAction)equalsBut:(id)sender {
    curNum = [self calculate:expression];
    [expression removeAllObjects];
    [expression addObject:curNum];
    state =-1;
}
- (IBAction)resetBut:(id)sender {
    curNum = @"";
    [expression removeAllObjects];
    calLabel.text = @"";
}
- (IBAction)decBut:(id)sender {
    [self command:@"."];
}
- (IBAction)openBut:(id)sender {
    state = 1;
    [self command:@"("];
}
- (IBAction)closeBut:(id)sender {
    state = 1;
    [self command:@")"];
}
- (IBAction)negBut:(id)sender {
    if([curNum isEqualToString:@""] || state == -1){
        if(state == -1){
            curNum = @"";
            [expression removeAllObjects];
            calLabel.text = @"";
            [expression addObject:(@"-")];
            curNum = [NSString stringWithFormat:@"%@%@",curNum,@"-"];
            calLabel.text = [NSString stringWithFormat:@"%@%@",calLabel.text , @"-"];
            state = 0;
        }else if(state == 0){
            NSInteger index = [expression indexOfObject:curNum];
            curNum = [NSString stringWithFormat:@"%@%@",curNum,@"-"];
            if (index != NSNotFound)
                [expression replaceObjectAtIndex:index withObject:curNum];
            else
            {
                [expression addObject:@"-"];
                curNum = @"-";
            }
            calLabel.text = [NSString stringWithFormat:@"%@%@",calLabel.text , @"-"];
        }else if (state == 1){
            [expression addObject:(@"-")];
            calLabel.text = [NSString stringWithFormat:@"%@%@",calLabel.text , @"-"];
            curNum = @"";
            state = 0;
        }
        

    }
}
- (IBAction)trigBut:(id)sender {
    if(trigisClicked){
        trigisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
        
    } else {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"trigView" owner:self options:nil];
        
        trigView = [array objectAtIndex:0];
        [trigView setBackgroundColor:self.view.backgroundColor];
        ((CalculatorPresentationController *)self.presentationController).calculatorExtension = trigView;
        trigisClicked = true;
        expoisClicked = false;
        extraisClicked = false;
        constisClicked = false;
        [self setPreferredContentSize:CGSizeMake(452, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
    }
    
    
}

- (IBAction)constBut:(id)sender {
    if(constisClicked){
        constisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"constView" owner:self options:nil];
        
        constView = [array objectAtIndex:0];
        [constView setBackgroundColor:self.view.backgroundColor];
        ((CalculatorPresentationController *)self.presentationController).calculatorExtension = constView;
        trigisClicked = false;
        expoisClicked = false;
        extraisClicked = false;
        constisClicked = true;
        [self setPreferredContentSize:CGSizeMake(382, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
        
        
    }
    
}
- (IBAction)rootBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"√"];
    state = 1;
    [self command:@"("];

    
}
- (IBAction)expoBut:(id)sender {
    if(expoisClicked){
        expoisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"expoView" owner:self options:nil];
        
        expoView = [array objectAtIndex:0];
        [expoView setBackgroundColor:self.view.backgroundColor];
        ((CalculatorPresentationController *)self.presentationController).calculatorExtension = expoView;
        trigisClicked = false;
        expoisClicked = true;
        extraisClicked = false;
        constisClicked = false;
        [self setPreferredContentSize:CGSizeMake(452, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
        
    }
}
-(void)clearcheck {
    if(state == -1){
        curNum = @"";
        [expression removeAllObjects];
        calLabel.text = @"";
    }
}
- (IBAction)sinBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"sin"];
    state = 1;
    [self command:@"("];
}
- (IBAction)cosBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"cos"];
    state = 1;
    [self command:@"("];
    
}
- (IBAction)tanBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"tan"];
    state = 1;
    [self command:@"("];
}
- (IBAction)arcsinBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"arcsin"];
    state = 1;
    [self command:@"("];
    
}
- (IBAction)arccosBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"arccos"];
    state = 1;
    [self command:@"("];
    
}
- (IBAction)arctanBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"arctan"];
    state = 1;
    [self command:@"("];
    
}
- (IBAction)extraBut:(id)sender {
    if(extraisClicked){
        extraisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"extraView" owner:self options:nil];
        
        extraView = [array objectAtIndex:0];
        [extraView setBackgroundColor:self.view.backgroundColor];
        ((CalculatorPresentationController *)self.presentationController).calculatorExtension = extraView;
        trigisClicked = false;
        expoisClicked = false;
        extraisClicked = true;
        constisClicked = false;
        [self setPreferredContentSize:CGSizeMake(382, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
        
    }
}
- (IBAction)xsquaredBut:(id)sender {
    state = 1;
    [self command:@"^"];
    state = 1;
    [self command:@"2"];

    
}
- (IBAction)xtotheyBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"^"];
    
}
- (IBAction)yrootxBut:(id)sender {
    state = 1;
    [self command:@"*"];
    state = 1;
    [self command:@"√"];
    state = 1;
    [self command:@"("];
}
- (IBAction)etothexBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"e"];
    state = 1;
    [self command:@"^"];
    
}
- (IBAction)lnxBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"ln"];
    state = 1;
    [self command:@"("];
}
- (IBAction)tothexBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"10"];
    state = 1;
    [self command:@"^"];
}
- (IBAction)logbase10But:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"log"];
    state = 1;
    [self command:@"("];
    
}
- (IBAction)factorialBut:(id)sender {
    state = 1;
    [self command:@"!"];

    
}
- (IBAction)radtodegreeBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"*"];
    state = 1;
    [self command:@"180"];
    state = 1;
    [self command:@"/"];
    state = 1;
    [self command:@"π"];
}
- (IBAction)degtoradBut:(id)sender {
    [self clearcheck];
    state = 1;
    [self command:@"*"];
    state = 1;
    [self command:@"π"];
    state = 1;
    [self command:@"/"];
    state = 1;
    [self command:@"180"];
}

- (IBAction)eBut:(id)sender {
    [self clearcheck];
    state = 0;
    [self command:@"e"];
}
- (IBAction)piBut:(id)sender {
    [self clearcheck];
    state = 0;
    [self command:@"π"];
}

- (void)removetrigView
{
    [trigView removeFromSuperview];
    trigView = nil;
}
- (void)removeexpoView
{
    [expoView removeFromSuperview];
    expoView = nil;
}
- (void)removeconstView
{
    [constView removeFromSuperview];
    constView = nil;
}
- (void)removeextraview
{
    [extraView removeFromSuperview];
    extraView = nil;
}


@end
