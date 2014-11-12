//
//  CalculatorVC.h
//  FloraDummy
//
//  Created by Riley Shaw on 11/1/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import "FormattedVC.h"

@interface CalculatorVC : FormattedVC

@property (strong, retain) IBOutlet UILabel *calLabel;
@property (strong, retain) IBOutlet UIButton *zeroBut;
@property (strong, retain) IBOutlet UIButton *oneBut;
@property (strong, retain) IBOutlet UIButton *twoBut;
@property (strong, retain) IBOutlet UIButton *threeBut;
@property (strong, retain) IBOutlet UIButton *fourBut;
@property (strong, retain) IBOutlet UIButton *fiveBut;
@property (strong, retain) IBOutlet UIButton *sixBut;
@property (strong, retain) IBOutlet UIButton *sevenBut;
@property (strong, retain) IBOutlet UIButton *eightBut;
@property (strong, retain) IBOutlet UIButton *nineBut;
@property (strong, retain) IBOutlet UIButton *equalsBut;
@property (strong, retain) IBOutlet UIButton *resetBut;
@property (strong, retain) IBOutlet UIButton *divBut;
@property (strong, retain) IBOutlet UIButton *mulBut;
@property (strong, retain) IBOutlet UIButton *subBut;
@property (strong, retain) IBOutlet UIButton *addBut;
@property (strong, retain) IBOutlet UIButton *decBut;
@property (strong, nonatomic) IBOutlet UIButton *rootBut;
@property (strong, nonatomic) IBOutlet UIButton *powBut;
@property (strong, nonatomic) IBOutlet UIButton *piBut;
@property (strong, nonatomic) IBOutlet UIButton *negBut;
@property (strong, nonatomic) IBOutlet UIButton *trigBut;
@property (strong, nonatomic) IBOutlet UIButton *expoBut;
@property (strong, nonatomic) IBOutlet UIButton *constBut;
@property (strong, nonatomic) IBOutlet UIButton *extraBut;
@property (nonatomic, retain) IBOutlet UIView *trigviewer;//inverse trig x^2 x^y e^x lnx 10^x log 10 (y root of x) fatorial , degree conversion abolute value
@property (strong, nonatomic) IBOutlet UIButton *arcsinBut;

@end
