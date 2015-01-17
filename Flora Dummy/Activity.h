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





// For Michael/Database

// Description of activity
@property(nonatomic, retain) NSString *activityDescription;

// Total points held in activity
@property(nonatomic) NSInteger totalPoints;

// Activity data
//
// For creation, just due key-nil
@property(nonatomic, retain) NSDictionary *activityData;

// Class ID
@property(nonatomic, retain) NSString *classID;


-(id)init;

@end
