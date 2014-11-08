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

int state = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    //[_addBut setImage:@"apple_yellow.png" forState:UIControlStateHighlighted];
    //[_zeroBut setTitle:[@"0"] forState:UIControlStateNormal];
   /* [Definitions outlineButton:_zeroBut];
    [Definitions outlineButton:_oneBut];
    [Definitions outlineButton:_twoBut];
    [Definitions outlineButton:_threeBut];
    [Definitions outlineButton:_fourBut];
    [Definitions outlineButton:_fiveBut];
    [Definitions outlineButton:_sixBut];       Unknown crashing issue here
    [Definitions outlineButton:_sevenBut];
    [Definitions outlineButton:_eightBut];
    [Definitions outlineButton:_nineBut];
    [Definitions outlineButton:_equalsBut];
    [Definitions outlineButton:_addBut];
    [Definitions outlineButton:_resetBut];
    [Definitions outlineButton:_subBut];
    [Definitions outlineButton:_divBut];
    [Definitions outlineButton:_mulBut];
    // Do any additional setup after loading the view from its nib.oij
    */
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
    [NSNotificationCenter defaultCenter] postNotificationName:(CAl *) object:<#(id)#>
    
}
- (IBAction)expoBut:(id)sender {
    
}
- (IBAction)constBut:(id)sender {
    
}
- (IBAction)extraBut:(id)sender {
    
}


@end
