//
//  WeatherManager.h
//  FloraDummy
//
//  Created by Michael Schloss on 11/21/14.
//  Copyright (c) 2014 Michael Schloss. All rights reserved.


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "LocationManager.h"
#import "WeatherItem+Parse.h"
#import <MapKit/MapKit.h>

@protocol WeatherManagerDelegate <NSObject>
-(void)didRecieveAndParseNewWeatherItem:(WeatherItem*)item;
@end

@interface WeatherManager : NSObject <LocationManagerDelegate>
@property (nonatomic, assign) id <WeatherManagerDelegate>delegate;

+(WeatherManager *)sharedManager;

-(void)startUpdatingLocation;
-(WeatherItem *)currentWeatherItem;


@end
