//
//  Activity.h
//  FloraDummy
//
//  Created by Zachary Nichols on 11/21/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject
{

}

// What is the name of the activity
@property(nonatomic, retain) NSString *name;

// When it was last modified/edited
@property(nonatomic, retain) NSDate *modDate;

// When it will be released
//
// If blank, assume it should be released now
@property(nonatomic, retain) NSDate *releaseDate;

// When is it due
@property(nonatomic, retain) NSDate *dueDate;

// Is there an image that should be associated with the activity
@property(nonatomic, retain) NSString *iconImageName;

// What is the alpha-numerical ID for this activity
@property(nonatomic, retain) NSString *activityID;

// Array of pages within the activity
@property(nonatomic, retain) NSArray *pageArray;

-(id)init;

@end
