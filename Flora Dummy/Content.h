//
//  Content.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/21/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Content : NSObject
{
    // What are the bounds of this piece of content
    CGRect *bounds;
}

// What type of controller is this
//
// Image, TextView
@property(nonatomic, retain) NSString *type;

// Dictionary with content for specific content
//
// If type is Image,
//     "Image" : NSString for image's name
//
// If type is TextView,
//     "Text" : NSString
//
//
@property(nonatomic, retain) NSDictionary *variableContent;

// Create content given JSON text
-(id)initWithContentsOfJSONText: (NSString *)jsonText;

@end
