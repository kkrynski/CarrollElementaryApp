//
//  LocationManager.m
//  FloraDummy
//
//  Created by Michael Schloss on 11/21/14.
//  Copyright (c) 2014 Michael Schloss. All rights reserved.


#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL didUpdate;

@end

@implementation LocationManager

# pragma mark - Singleton Methods

+ (id)sharedManager {
    static LocationManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        self.didUpdate = NO;
    }
    return self;
}

- (void)startUpdates {
    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    }
  
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your location could not be determined. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];     
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.didUpdate) return;
    
    self.didUpdate = YES;
    
        // Disable future updates to save power.
    [self.locationManager stopUpdatingLocation];
    
    for (CLLocation *location in locations)
        [self.delegate didLocateNewUserLocation:location];
}

@end
