//
//  EquationFormatter.m
//  Flora Dummy
//
//  Created by Zach Nichols on 1/30/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "EquationFormatter.h"

@interface EquationFormatter ()
{
    NSArray *opsArray;
}
@end

@implementation EquationFormatter

-(NSArray *)returnBoxesForEquationString: (NSString *)eqStr
{
    // NOTE: ADD EQUALITY EXPRESSIONs
    opsArray = [NSArray arrayWithObjects:@"+", @"-", @"*", @"/", @"^", @"(", @")", @"=", nil];
    
    NSMutableArray *boxes = [[NSMutableArray alloc]init];
    
    NSArray *stringComponents = [eqStr componentsSeparatedByString:@"_"];
    
    for (NSString *component in stringComponents)
    {
        if (!component || [component isEqualToString:@""])
        {

        }else
        {
            NSString *firstChar = [component substringWithRange:NSMakeRange(0,1)];
            
            // Test to see if there is a variable
            if ([firstChar isEqualToString:@"#"])
            {
                // This indicates a variable
                NSString *varStr = [component substringWithRange:NSMakeRange(1,component.length-1)];
                
                [boxes addObject:[self createTextBoxForString:varStr]];
                
                //break;
            }
            
            // Test to see if there is an answer box requested
            if ([firstChar isEqualToString:@"?"])
            {
                NSString *answerStr = [component substringWithRange:NSMakeRange(1,component.length-1)];
                
                [boxes addObject:[self createAnswerBoxForAnswer:answerStr]];
                
                //break;
            }
            
            // Test to see if the string is a number
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            if ([component rangeOfCharacterFromSet:notDigits].location == NSNotFound)
            {
                // String consists only of the digits 0 through 9
                NSNumber *num = [NSNumber numberWithFloat:component.floatValue];
                
                [boxes addObject:[self createNumberTextBoxForNumber:num]];
                
                //break;
            }
            
            // Test for characters
            for (NSString *opStr in opsArray)
            {
                if ([firstChar isEqualToString:opStr])
                {
                    // We have an operator
                    [boxes addObject:[self createOperatorBoxForOp:component]];
                    
                    //break;
                }
            }
        }
        
    }

    return boxes;
}

// Individual methods for creating box dictionaries

-(NSDictionary *)createOperatorBoxForOp: (NSString *)opStr;
{
    NSMutableDictionary *opBox = [[NSMutableDictionary alloc] init];
    
    [opBox setObject:@"Operator" forKey:@"Type"];
    [opBox setObject:opStr forKey:@"Subtype"];
    
    return opBox;
}

-(NSDictionary *)createTextBoxForString: (NSString *)str;
{
    NSMutableDictionary *textBox = [[NSMutableDictionary alloc] init];
    
    [textBox setObject:@"Text" forKey:@"Type"];
    [textBox setObject:@"String" forKey:@"Subtype"];
    
    return textBox;
}

-(NSDictionary *)createNumberTextBoxForNumber: (NSNumber *)num;
{
    NSMutableDictionary *textBox = [[NSMutableDictionary alloc] init];
    
    [textBox setObject:@"Text" forKey:@"Type"];
    [textBox setObject:@"Num_Plain" forKey:@"Subtype"];
    
    NSMutableDictionary *internalDict = [[NSMutableDictionary alloc]init];
    [internalDict setObject:@"Num_Plain" forKey:@"Type"];
    [internalDict setObject:num forKey:@"Value"];
    
    [textBox setObject:@[internalDict] forKey:@"V_Objects"];

    return textBox;
}

-(NSDictionary *)createAnswerBoxForAnswer: (NSString *)answerStr;
{
    NSMutableDictionary *ansBox = [[NSMutableDictionary alloc] init];
    
    [ansBox setObject:@"Answer" forKey:@"Type"];
    [ansBox setObject:@"Num_Plain" forKey:@"Subtype"];
    
    NSMutableDictionary *internalDict = [[NSMutableDictionary alloc]init];
    internalDict = nil;
    internalDict = [[NSMutableDictionary alloc]init];
    [internalDict setObject:@"Num_Plain" forKey:@"Type"];
        
    [ansBox setObject:internalDict forKey:@"V_Objects"];
    
    return ansBox;
}

@end
