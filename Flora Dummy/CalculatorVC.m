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
    [calLabel setBackgroundColor:[Definitions lighterColorForColor:backgroundColor]];
    expression = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)command:(NSString *)val{
    if(state == -1){
        curNum = @"";
        [expression removeAllObjects];
        calLabel.text = @"";
        curNum = [NSString stringWithFormat:@"%@%@",curNum,val];
        calLabel.text = [NSString stringWithFormat:@"%@%@",calLabel.text , val];
    }else if(state == 0){
        NSInteger index = [expression indexOfObject:curNum];
        curNum = [NSString stringWithFormat:@"%@%@",curNum,val];
        if (index != NSNotFound)
            [expression replaceObjectAtIndex:index withObject:curNum];
        else
        {
            [expression addObject:val];
            curNum = val;
        }
        //curNum = @"";
        calLabel.text = [NSString stringWithFormat:@"%@%@",calLabel.text , val];
    }else if (state == 1){
        //[curNum isEqualToString:@""] == NO ? [expression addObject:(curNum)]:nil;
        [expression addObject:(val)];
        calLabel.text = [NSString stringWithFormat:@"%@%@",calLabel.text , val];
        curNum = @"";
        state = 0;
    }
}
-(NSString *)calculate:(NSMutableArray *)express{

    if(state == 0){
        NSLog(@"Express array: %@", express);
        //[express addObject:(curNum)];
        
        ///curNum = @"";
        NSUInteger openParenIndex = [express indexOfObject:@"("];
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
                        NSArray *insideParenArray = [express subarrayWithRange:NSMakeRange(openParenIndex + 1, (closeParenIndex - openParenIndex) - 1)];
                        NSLog(@"Inside Parentheses Array: %@", insideParenArray);
                        
                        NSString *answerInsideParens = [self calculate:[NSMutableArray arrayWithArray:insideParenArray]];
                        
                        [express removeObjectsInRange:NSMakeRange(openParenIndex, (closeParenIndex - openParenIndex) + 1)];
                        NSLog(@"Answer: %@", answerInsideParens);
                        [express insertObject:answerInsideParens atIndex:openParenIndex];
                        
                        i -= NSMakeRange(openParenIndex, (closeParenIndex - openParenIndex) + 1).length;
                        i++;
                        NSLog(@"%@", express);
                    }
                }
            }
        }

        
       /* for(int i = 0; i < [express count]; i++){
            if([express[i] isEqualToString:@"("]){
                for(int j = 0; j < [express count]; j++){
                    if(a){
                        NSMutableArray *temp = [NSMutableArray array];
                        
                        
                        
                        
                        for(int r = i+1; r < j; r++){
                            [temp addObject:(express[r])];
                            [express removeObjectAtIndex:r];
                            r--;
                            j--;
                        }
                        
                        [express removeObjectAtIndex:i];
                        [express removeObjectAtIndex:i];
                        NSLog(@"%@",[self calculate:temp]);
                        [express insertObject:[self calculate:temp] atIndex:(i)];
                        [express removeObject:@""];
                        NSLog(@"%@", express);
                        break;
                    }
                }
            }
        }*/
        
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
        curNum = express[0];
        calLabel.text = [[express[0] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
        //state = -1;
        return curNum;
    }
    return curNum;
}
-(NSString *)roundem:(int)index{
    NSString *temp = expression[0];
    if(index == 0){
        return [NSString stringWithFormat:@"%.0f",temp.doubleValue];
    }else if (index == 1){
        return [NSString stringWithFormat:@"%.1f",temp.doubleValue];
    }else if (index == 2){
        return [NSString stringWithFormat:@"%.2f",temp.doubleValue];
    }else if (index == 3){
        return [NSString stringWithFormat:@"%.3f",temp.doubleValue];
    }else if (index == 4){
        return [NSString stringWithFormat:@"%.4f",temp.doubleValue];
    }else if (index == 5){
        return [NSString stringWithFormat:@"%.5f",temp.doubleValue];
    }else{
        return [NSString stringWithFormat:@"%.6f",temp.doubleValue];
    }
    
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
    [self command:@"+" ];
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

- (IBAction)sinBut:(id)sender {
    
}
- (IBAction)cosBut:(id)sender {
    
    
}
- (IBAction)tanBut:(id)sender {
    
}
- (IBAction)arcsinBut:(id)sender {
    
    
}
- (IBAction)arccosBut:(id)sender {
    
}
- (IBAction)arctanBut:(id)sender {
    
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
    
}
- (IBAction)xtotheyBut:(id)sender {
    
}
- (IBAction)yrootxBut:(id)sender {
    
}
- (IBAction)etothexBut:(id)sender {
    
}
- (IBAction)lnxBut:(id)sender {
    
}
- (IBAction)tothexBut:(id)sender {
    
}
- (IBAction)logbase10But:(id)sender {
    
}
- (IBAction)factorialBut:(id)sender {
    
}
- (IBAction)radtodegreeBut:(id)sender {
    
}
- (IBAction)degtoradBut:(id)sender {
    
}

- (IBAction)eBut:(id)sender {
    
}
- (IBAction)piBut:(id)sender {
    
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
