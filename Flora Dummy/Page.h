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

// An array of content (images, textviews, etc)
@property(nonatomic, retain) NSArray *contentArray;

// Given JSON text, create the page
-(id)initWithContentsOfJSONText: (NSString *)jsonText;
-(id)init;


@end
