//
//  WeatherManager.m
//  FloraDummy
//
//  Created by Michael Schloss on 11/21/14.
//  Copyright (c) 2014 Michael Schloss. All rights reserved.

#import "WeatherManager.h"

@interface WeatherManager ()
@property (nonatomic, strong) LocationManager *locationManager;
@end

@implementation WeatherManager

# pragma mark - Singleton Methods

+ (WeatherManager *)sharedManager {
    WeatherManager *_sharedManager;
    _sharedManager = [[WeatherManager alloc] init];
    return _sharedManager;
}

- (void)startUpdatingLocation {
    self.locationManager = [LocationManager sharedManager];
    self.locationManager.delegate = self;
    [self.locationManager startUpdates];
}

- (WeatherItem *)currentWeatherItem {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"currentItem"];
    
    if (!data) {
        NSArray *forecast = [NSArray arrayWithObjects:@"66",@"76",@"56",@"94",@"32", nil];
        
        NSArray *forecastConditions = [NSArray arrayWithObjects:@"Sunny",@"Rainy",@"Sunny",@"Cloudy",@"Heavy Rain", nil];
        
        WeatherItem *defaultItem = [[WeatherItem alloc] initWithCurrentTemp:@"100" currentDay:@"Mon" Forecast:forecast andForecastConditions:forecastConditions];
        defaultItem.indexForWeatherMap = [self indexForTemperature:defaultItem.weatherCurrentTemp];
        defaultItem.weatherWindSpeed = @"5";
        defaultItem.weatherCode = @"116";
        defaultItem.weatherCurrentTempImage = [UIImage imageNamed:@"sun.png"];
        defaultItem.weatherHumidity = @"50";
        defaultItem.weatherPrecipitationAmount = @"0";
        
        UIImage *sun = [UIImage imageNamed:@"sun.png"];
        defaultItem.weatherForecastConditionsImages = [NSArray arrayWithObjects: sun, sun, sun, sun, sun, nil];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:defaultItem];
        [defaults setObject:data forKey:@"currentItem"];
        [defaults synchronize];
        
        [self startUpdatingLocation];
        
        return defaultItem;
    } else {
        WeatherItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return item;
    }
}

#pragma mark - Location Delegate Methods 

- (void)didLocateNewUserLocation:(CLLocation *)location; {
    
    //Get the locatio  zipcode using CLGeocoder
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:
    ^(NSArray *placemarks, NSError *error) {
        if (placemarks) {
            MKPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *zip = [placemark.addressDictionary objectForKey:@"ZIP"];
            NSString *queryString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%@&format=json&num_of_days=5&key=urwds2jpg3uytmbygq47cmgn", zip];
            [self executeFetchForQueryString:queryString];
        } else if (error) {
            NSLog(@"Error getting zipcode from geocoder: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Newtorking Methods 

-(void)executeFetchForQueryString:(NSString *)queryString {
    queryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //Create JSONData using the string 
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:queryString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    //Results from JSON Data 
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonData 
                                                            options:kNilOptions
                                                              error:&error];
    
    WeatherItem *item = [WeatherItem itemFromWeatherDictionary:results];
    
    if (self.delegate) {
        //Save in NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [defaults setObject:data forKey:@"currentItem"];
        [defaults synchronize];
        
        [self.delegate didRecieveAndParseNewWeatherItem:item];
    }
}

#pragma mark - Helper methods
                               
-(int)indexForTemperature:(NSString *)temp {
        int temperatureInt = temp.intValue;
        
        if (temperatureInt <=8 && temperatureInt >=0)
        {
            return 12;
        } else if (temperatureInt <=17 && temperatureInt >=9)
        {
            return 11;
        } else if (temperatureInt <=26 && temperatureInt >=18)
        {
            return 10;
        } else if (temperatureInt <=35 && temperatureInt >=27)
        {
            return 9;
        } else if (temperatureInt <=44 && temperatureInt >=36)
        {
            return 8;
        } else if (temperatureInt <=53 && temperatureInt >=45)
        {
            return 7;
        } else if (temperatureInt <=62 && temperatureInt >=54)
        {
            return 6;
        } else if (temperatureInt <=71 && temperatureInt >=63)
        {
            return 5;
        } else if (temperatureInt <=80 && temperatureInt >=72)
        {
            return 4;
        } else if (temperatureInt <=89 && temperatureInt >=81)
        {
            return 3;
        } else if (temperatureInt <=97 && temperatureInt >=90)
        {
            return 2;
        } else if (temperatureInt <=100 && temperatureInt >=98)
        {
            return 1;
        } else if (temperatureInt <=200 && temperatureInt >=101)
        {
            return 0;
        }
        return 0;
    }                      

@end
