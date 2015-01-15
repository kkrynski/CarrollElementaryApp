//
//  ModuleVC.h
//  Flora Dummy
//
//  Created by Zach Nichols on 3/27/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageVC.h"

@interface ModuleVC : PageVC
{
    
}

@property(nonatomic, retain) NSMutableArray *contentArray;


-(id)initWithContent: (NSArray *) content;

@end
