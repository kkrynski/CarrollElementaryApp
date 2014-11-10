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

NSString *num1;
NSString *num2;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    num1 = @"";
    num2 = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)command:(NSString *)val{
    if (operator == 0){
        num1 = [NSString stringWithFormat:@"%@%@",num1 ,val];
        calLabel.text = num1;
    } else {
        num2 = [NSString stringWithFormat:@"%@%@",num2 ,val];
        calLabel.text = num2;
    }
  }
-(void)calculate{
    
    if(operator == 1){
        num1 = [NSString stringWithFormat:@"%f",(num1.doubleValue + num2.doubleValue)];
        NSRange searchResult = [num1 rangeOfString:@"."];
        bool tempo = false;
        int index = 6;
        for(int i = 0; i<6;i++){
            if(tempo == false){
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i, 1)]);
                if([temp isEqualToString:@"0"]){
                    tempo = true;
                    index = i-1;
                }
            } else {
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i,1)]);
                if(![temp isEqualToString:@"0"]){
                    tempo = false;
                    index = 6;
                }
            }
        }
        num1 = [self roundem:index];
        calLabel.text = num1;
        num2 = @"";
    }else if(operator == 2){
        num1 = [NSString stringWithFormat:@"%f",(num1.doubleValue - num2.doubleValue)];
        NSRange searchResult = [num1 rangeOfString:@"."];
        bool tempo = false;
        int index = 6;
        for(int i = 0; i<6;i++){
            if(tempo == false){
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i, 1)]);
                if([temp isEqualToString:@"0"]){
                    tempo = true;
                    index = i-1;
                }
            } else {
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i,1)]);
                if(![temp isEqualToString:@"0"]){
                    tempo = false;
                    index = 6;
                }
            }
        }
        num1 = [self roundem:index];
        calLabel.text = num1;
        num2 = @"";
    }else if(operator == 3){
        num1 = [NSString stringWithFormat:@"%f",(num1.doubleValue * num2.doubleValue)];
        NSRange searchResult = [num1 rangeOfString:@"."];
        bool tempo = false;
        int index = 6;
        for(int i = 0; i<6;i++){
            if(tempo == false){
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i, 1)]);
                if([temp isEqualToString:@"0"]){
                    tempo = true;
                    index = i-1;
                }
            } else {
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i,1)]);
                if(![temp isEqualToString:@"0"]){
                    tempo = false;
                    index = 6;
                }
            }
        }
        num1 = [self roundem:index];
        calLabel.text = num1;
        num2 = @"";
    }else if(operator == 4){
        if([num2 isEqualToString:@"0"]){
            num1 = @"0";
        } else{
            num1 = [NSString stringWithFormat:@"%f",(num1.doubleValue / num2.doubleValue)];
            NSRange searchResult = [num1 rangeOfString:@"."];
            bool tempo = false;
            int index = 6;
            for(int i = 0; i<6;i++){
                if(tempo == false){
                    NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i, 1)]);
                    if([temp isEqualToString:@"0"]){
                        tempo = true;
                        index = i-1;
                    }
                } else {
                    NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i,1)]);
                    if(![temp isEqualToString:@"0"]){
                        tempo = false;
                        index = 6;
                    }
                }
            }
            num1 = [self roundem:index];
            calLabel.text = num1;
            num2 = @"";
        }
    }else if(operator == 5){
            num1 = [NSString stringWithFormat:@"%f",(pow(num1.doubleValue,num2.doubleValue))];
            NSRange searchResult = [num1 rangeOfString:@"."];
            bool tempo = false;
            int index = 6;
            for(int i = 0; i<6;i++){
                if(tempo == false){
                    NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i, 1)]);
                    if([temp isEqualToString:@"0"]){
                        tempo = true;
                        index = i-1;
                    }
                } else {
                    NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i,1)]);
                    if(![temp isEqualToString:@"0"]){
                        tempo = false;
                        index = 6;
                    }
                }
            }
            num1 = [self roundem:index];
            calLabel.text = num1;
            num2 = @"";
    }
    operator = 0;
    num2 = @"";
}
-(NSString *)roundem:(int)index{
    if(index == 0){
        return [NSString stringWithFormat:@"%.0f",num1.doubleValue];
    }else if (index == 1){
        return [NSString stringWithFormat:@"%.1f",num1.doubleValue];
    }else if (index == 2){
        return [NSString stringWithFormat:@"%.2f",num1.doubleValue];
    }else if (index == 3){
        return [NSString stringWithFormat:@"%.3f",num1.doubleValue];
    }else if (index == 4){
        return [NSString stringWithFormat:@"%.4f",num1.doubleValue];
    }else if (index == 5){
        return [NSString stringWithFormat:@"%.5f",num1.doubleValue];
    }else{
        return [NSString stringWithFormat:@"%.6f",num1.doubleValue];
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
    if(operator == 0){
        operator = 1;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 1;
    }
   
}
- (IBAction)subBut:(id)sender {
    if(operator == 0){
        operator = 2;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 2;
    }
}
- (IBAction)mulBut:(id)sender {
    if(operator == 0){
        operator = 3;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 3;
    }
}
- (IBAction)divBut:(id)sender {
    if(operator == 0){
        operator = 4;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 4;
    }
}
- (IBAction)equalsBut:(id)sender {
    [self calculate];
}
- (IBAction)resetBut:(id)sender {
    calLabel.text = @"0";
    operator = 0;
    num1 = @"";
    num2 = @"";
}
- (IBAction)decBut:(id)sender {
    [self command:@"."];
}
- (IBAction)powBut:(id)sender {
    if(operator == 0){
        operator = 5;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 5;
    }
}
- (IBAction)rootBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(sqrt(num1.doubleValue))];
        NSRange searchResult = [num1 rangeOfString:@"."];
        bool tempo = false;
        int index = 6;
        for(int i = 0; i<6;i++){
            if(tempo == false){
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i, 1)]);
                if([temp isEqualToString:@"0"]){
                    tempo = true;
                    index = i-1;
                }
            } else {
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i,1)]);
                if(![temp isEqualToString:@"0"]){
                    tempo = false;
                    index = 6;
                }
            }
        }
        num1 = [self roundem:index];
        calLabel.text = num1;
        num2 = @"";
    } else {
        [self calculate];
        num1 = [NSString stringWithFormat:@"%f",(sqrt(num1.doubleValue))];
        NSRange searchResult = [num1 rangeOfString:@"."];
        bool tempo = false;
        int index = 6;
        for(int i = 0; i<6;i++){
            if(tempo == false){
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i, 1)]);
                if([temp isEqualToString:@"0"]){
                    tempo = true;
                    index = i-1;
                }
            } else {
                NSString *temp = ([num1 substringWithRange:NSMakeRange(searchResult.location + i,1)]);
                if(![temp isEqualToString:@"0"]){
                    tempo = false;
                    index = 6;
                }
            }
        }
        num1 = [self roundem:index];
        calLabel.text = num1;
        num2 = @"";
    }
}
- (IBAction)piBut:(id)sender {
   if([num1 isEqualToString:@""]) {
       num1 = [NSString stringWithFormat:@"%f",(3.141593)];
       calLabel.text = num1;
   } else {
       num2 = [NSString stringWithFormat:@"%f",(3.141593)];
       calLabel.text = num2;

   }
}
- (IBAction)negBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        if([([num1 substringWithRange:NSMakeRange(0, 1)]) isEqualToString:@"-"]){
            num1 =[num1 substringFromIndex:(1)];
            calLabel.text = num1;
        } else {
            num1 = [NSString stringWithFormat:@"-%@",num1];
            calLabel.text = num1;
        }
    } else {
        if([([num2 substringWithRange:NSMakeRange(0, 1)]) isEqualToString:@"-"]){
            num2 =[num2 substringFromIndex:(1)];
            calLabel.text = num2;
        } else {
            num2 = [NSString stringWithFormat:@"-%@",num2];
            calLabel.text = num2;
        }
    }
}
- (IBAction)trigBut:(id)sender {
    if(trigisClicked){
        trigisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
        [self performSelector:@selector(removetrigView) withObject:nil afterDelay:[Definitions transitionDuration]];
    } else {
            [self setPreferredContentSize:CGSizeMake(384, 508)];
            [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"trigView" owner:nil options:nil];
            
            trigView = [array objectAtIndex:0];
            [trigView setBackgroundColor:self.view.backgroundColor];
            [self.view addSubview:trigView];
        NSString *position = [Definitions positionOfCalculatorOnScreen:self];
        if ([position isEqualToString:@"Left"])
            [trigView setCenter:CGPointMake(0 - trigView.frame.size.width/2.0, trigView.frame.size.height/2.0)];
        else if ([position isEqualToString:@"Right"])
            [trigView setCenter:CGPointMake(self.view.frame.size.width + trigView.frame.size.width/2.0, trigView.frame.size.height/2.0)];
        trigisClicked = true;
        expoisClicked = false;
        extraisClicked = false;
        constisClicked = false;
    }
    
}
- (IBAction)expoBut:(id)sender {
    
}
- (IBAction)constBut:(id)sender {
    if(constisClicked){
        constisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
        [self performSelector:@selector(removeconstView) withObject:nil afterDelay:[Definitions transitionDuration]];
    } else {
        [self setPreferredContentSize:CGSizeMake(384, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"constView" owner:nil options:nil];
        
        constView = [array objectAtIndex:0];
        [constView setBackgroundColor:self.view.backgroundColor];
        [self.view addSubview:constView];
        NSString *position = [Definitions positionOfCalculatorOnScreen:self];
        if ([position isEqualToString:@"Left"])
            [constView setCenter:CGPointMake(0 - constView.frame.size.width/2.0, constView.frame.size.height/2.0)];
        else if ([position isEqualToString:@"Right"])
            [constView setCenter:CGPointMake(self.view.frame.size.width + constView.frame.size.width/2.0, constView.frame.size.height/2.0)];
        trigisClicked = false;
        expoisClicked = false;
        extraisClicked = false;
        constisClicked = true;
    }
    
}
- (IBAction)extraBut:(id)sender {
    if(extraisClicked){
        constisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
        [self performSelector:@selector(removeconstView) withObject:nil afterDelay:[Definitions transitionDuration]];
    } else {
        [self setPreferredContentSize:CGSizeMake(384, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"constView" owner:nil options:nil];
        
        constView = [array objectAtIndex:0];
        [constView setBackgroundColor:self.view.backgroundColor];
        [self.view addSubview:constView];
        NSString *position = [Definitions positionOfCalculatorOnScreen:self];
        if ([position isEqualToString:@"Left"])
            [constView setCenter:CGPointMake(0 - constView.frame.size.width/2.0, constView.frame.size.height/2.0)];
        else if ([position isEqualToString:@"Right"])
            [constView setCenter:CGPointMake(self.view.frame.size.width + constView.frame.size.width/2.0, constView.frame.size.height/2.0)];
        trigisClicked = false;
        expoisClicked = false;
        extraisClicked = false;
        constisClicked = true;
    }
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
