//
//  WeatherItem+Parse.m
//  FloraDummy
//
//  Created by Michael Schloss on 11/21/14.
//  Copyright (c) 2014 Michael Schloss. All rights reserved.

#import "WeatherItem.h"

@interface WeatherItem (Parse)

+(WeatherItem *)itemFromWeatherDictionary:(NSDictionary *)dict;

@end
