//
//  LocationManager.h
//  FloraDummy
//
//  Created by Michael Schloss on 11/21/14.
//  Copyright (c) 2014 Michael Schloss. All rights reserved.


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>
- (void) didLocateNewUserLocation:(CLLocation *)location;
@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>
@property (nonatomic, retain) id <LocationManagerDelegate>delegate;

+ (id)sharedManager;
- (void)startUpdates;

@end