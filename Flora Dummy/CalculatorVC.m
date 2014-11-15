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
    [calLabel setBackgroundColor:[Definitions lighterColorForColor:backgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)command:(NSString *)val{
    if (operator == 0){
        num1 = [NSString stringWithFormat:@"%@%@",num1 ,val];
        calLabel.text = num1;
    } else if(operator == -1){
        num1 = [NSString stringWithFormat:@"%@",val];
        calLabel.text = num1;
        operator = 0;
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
    }else if(operator == 6){
        num1 = [NSString stringWithFormat:@"%f",(pow(num2.doubleValue,1/num1.doubleValue))];
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
    if(operator == 0| operator == -1){
        operator = 1;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 1;
    }
   
}
- (IBAction)subBut:(id)sender {
    if(operator == 0| operator == -1){
        operator = 2;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 2;
    }
}
- (IBAction)mulBut:(id)sender {
    if(operator == 0| operator == -1){
        operator = 3;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 3;
    }
}
- (IBAction)divBut:(id)sender {
    if(operator == 0 || operator == -1){
        operator = 4;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 4;
    }
}
- (IBAction)equalsBut:(id)sender {
    [self calculate];
    operator = -1;
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
        
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self setPreferredContentSize:CGSizeMake(452, 508)];
            [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"trigView" owner:nil options:nil];
            
            trigView = [array objectAtIndex:0];
            [trigView setBackgroundColor:self.view.backgroundColor];
        ((CalculatorPresentationController *)self.presentationController).calculatorExtension = trigView;
        trigisClicked = true;
        expoisClicked = false;
        extraisClicked = false;
        constisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
    }
    
}

- (IBAction)constBut:(id)sender {
    if(constisClicked){
        constisClicked = false;
           } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self setPreferredContentSize:CGSizeMake(382, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"constView" owner:nil options:nil];
        
        constView = [array objectAtIndex:0];
        [constView setBackgroundColor:self.view.backgroundColor];
        ((CalculatorPresentationController *)self.presentationController).calculatorExtension = constView;
        trigisClicked = false;
        expoisClicked = false;
        extraisClicked = false;
        constisClicked = true;
               [self setPreferredContentSize:CGSizeMake(304, 508)];
               [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];

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
- (IBAction)expoBut:(id)sender {
    if(expoisClicked){
        expoisClicked = false;
       
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self setPreferredContentSize:CGSizeMake(382, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"expoView" owner:nil options:nil];
        
        expoView = [array objectAtIndex:0];
        [expoView setBackgroundColor:self.view.backgroundColor];
        ((CalculatorPresentationController *)self.presentationController).calculatorExtension = expoView;
        trigisClicked = false;
        expoisClicked = true;
        extraisClicked = false;
        constisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
    }
}
- (IBAction)sinBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(sin(num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(sin(num1.doubleValue))];
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
- (IBAction)cosBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(cos(num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(cos(num1.doubleValue))];
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
- (IBAction)tanBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(tan(num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(tan(num1.doubleValue))];
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
- (IBAction)arcsinBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(1/sin(num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(1/sin(num1.doubleValue))];
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
- (IBAction)arccosBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(1/cos(num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(1/cos(num1.doubleValue))];
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
- (IBAction)arctanBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(1/tan(num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(1/tan(num1.doubleValue))];
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
- (IBAction)extraBut:(id)sender {
    if(extraisClicked){
        extraisClicked = false;
        [self setPreferredContentSize:CGSizeMake(304, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillDecreaseSizeNotification] object:nil];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
       
               NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"extraView" owner:nil options:nil];
        
        extraView = [array objectAtIndex:0];
        [extraView setBackgroundColor:self.view.backgroundColor];
        ((CalculatorPresentationController *)self.presentationController).calculatorExtension = extraView;
        trigisClicked = false;
        expoisClicked = false;
        extraisClicked = true;
        constisClicked = false;
         [self setPreferredContentSize:CGSizeMake(382, 508)];
        [[NSNotificationCenter defaultCenter] postNotificationName:[CalculatorPresentationController CalculatorWillIncreaseSizeNotification] object:nil];

    }}
- (IBAction)xsquaredBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(pow(num1.doubleValue, 2.0))];
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
        num1 = [NSString stringWithFormat:@"%f",(pow(num1.doubleValue, 2.0))];
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
- (IBAction)xtotheyBut:(id)sender {
    if(operator == 0| operator == -1){
        operator = 5;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 5;
    }
}
- (IBAction)yrootxBut:(id)sender {
    if(operator == 0| operator == -1){
        operator = 6;
    } else if(![num2 isEqualToString:@""]){
        [self calculate];
        operator = 6;
    }
}
- (IBAction)etothexBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(pow(M_E, num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(pow(M_E, num1.doubleValue))];
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
- (IBAction)lnxBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(log(num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(log(num1.doubleValue))];
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
- (IBAction)tothexBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(pow(10,num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(pow(10,num1.doubleValue))];
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
- (IBAction)logbase10But:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(log10(num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(log10(num1.doubleValue))];
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
- (IBAction)factorialBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(tgamma(num1.doubleValue))];
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
        num1 = [NSString stringWithFormat:@"%f",(tgamma(num1.doubleValue))];
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
- (IBAction)radtodegreeBut:(id)sender {
    if([num2 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(180/M_PI*num1.doubleValue)];
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
        num1 = [NSString stringWithFormat:@"%f",(180/M_PI*num1.doubleValue)];
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
- (IBAction)eBut:(id)sender {
    if([num1 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(M_E)];
        calLabel.text = num1;
    } else {
        num2 = [NSString stringWithFormat:@"%f",(M_E)];
        calLabel.text = num2;
        
    }
}
- (IBAction)piBut:(id)sender {
    if([num1 isEqualToString:@""]) {
        num1 = [NSString stringWithFormat:@"%f",(M_PI)];
        calLabel.text = num1;
    } else {
        num2 = [NSString stringWithFormat:@"%f",(M_PI)];
        calLabel.text = num2;
        
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
