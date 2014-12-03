//
//  ClassConversions.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/23/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Activity.h"
#import "Page.h"
#import "Content.h"

@interface ClassConversions : NSObject

// Activity
-(NSDictionary *)dictionaryForActivity: (Activity *)a;
-(Activity *)activityFromDictionary: (NSDictionary *)dict;

// Page
-(NSDictionary *)dictionaryForPage: (Page *)p;
-(Page *)pageFromDictionary: (NSDictionary *)dict;

// Content
-(NSDictionary *)dictionaryForContent: (Content *)c;
-(Content *)contentFromDictionary: (NSDictionary *)dict;

@end
