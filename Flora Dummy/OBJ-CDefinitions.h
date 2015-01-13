//
//  OBJ-CDefinitions.h
//  FloraDummy
//
//  Created by Michael Schloss on 11/28/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserState)
{
    UserStateUserIsStudent,
    UserStateUserIsTeacher,
    UserStateUserInvalid
};

#define ActivityDataLoaded @"ActivityDataLoaded"
#define UserAccountsDownloaded @"User Accounts Downloaded Notification"
#define UserLoggedIn @"User Logged In Notification"

#define PageManagerShouldContinuePresentation @"Page Manager Should Continue Presentation"

//Private Defininitions class for UITabBar Transition
@interface OBJ_CDefinitions : NSObject

+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber;

+ (UIView*)addShadowToView:(UIView*)view reverse:(BOOL)reverse;

+ (NSArray*)createSnapshots:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates;

+ (UIView *) createSnapshotFromView:(UIView *)view afterUpdates:(BOOL)afterUpdates location:(CGFloat)offset left:(BOOL)left withNumberOfFolds:(int)folds;

@end
