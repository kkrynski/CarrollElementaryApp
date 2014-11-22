//
//  WeatherManager.h
//  Weatherli
//
//  Created by Ahmed Eid on 5/14/12.
//  Copyright (c) 2012 Ahmed Eid. All rights reserved.
//  This file is part of Weatherli.
//
//  Weatherli is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Weatherli is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Weatherli.  If not, see <http://www.gnu.org/licenses/>.
//


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
