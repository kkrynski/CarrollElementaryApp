//
//  WeatherItem.h
//  FloraDummy
//
//  Created by Michael Schloss on 11/21/14.
//  Copyright (c) 2014 Michael Schloss. All rights reserved.

#import <Foundation/Foundation.h>

@interface WeatherItem : NSObject <NSCoding>

@property (nonatomic) int indexForWeatherMap;
@property (nonatomic, strong) NSString *weatherCurrentTemp;
@property (nonatomic, strong) NSArray *nextDays;

@property (nonatomic, strong) NSString *weatherCurrentTempImage;
@property (nonatomic, strong) NSString *weatherCurrentDay;
@property (nonatomic, strong) NSArray *weatherForecast;
@property (nonatomic, strong) NSArray *weatherForecastConditions;
@property (nonatomic, strong) NSArray *weatherForecastConditionsImages;

@property (nonatomic, strong) NSString *weatherCode;
@property (nonatomic, strong) NSString *weatherPrecipitationAmount;
@property (nonatomic, strong) NSString *weatherHumidity;
@property (nonatomic, strong) NSString *weatherWindSpeed;

-(id)initWithCurrentTemp:(NSString *)currentTemp currentDay:(NSString *)currentDay Forecast:(NSArray *)forecast andForecastConditions:(NSArray *)forecastConditions;

@end
