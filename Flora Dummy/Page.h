//
//  Page.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/21/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject
{

}

// What type of page are we dealing with
@property(nonatomic, retain) NSString *pageVCType;

// A dictionary of content (images, textviews, etc)
//
// "Content" = Array of content
//
// "Question" = Question (string)
// "Answers" = Array of answers (strings, either answers or image names)
// "CorrectIndex" = index of correct answer (NSNumber)
//
// "Word" = word for spelling test
// "Recording" = voice recording for spelling test
//
// "Text" = text
//
// "Equestion" = string representing numerical equation
// "Answer" = string representing equation's answer
//
@property(nonatomic, retain) NSDictionary *variableContentDict;

// Given JSON text, create the page
-(id)initWithContentsOfJSONText: (NSString *)jsonText;
-(id)init;


@end
