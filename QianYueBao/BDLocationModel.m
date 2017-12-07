//
//  BDLocationModel.m
//  QianYueBao
//
//  Created by tenpastnine-ios-dev on 17/3/27.
//  Copyright © 2017年 Black. All rights reserved.
//

#import "BDLocationModel.h"
#import "WGS84TOGCJ02.h"
#import "BDLocationChange.h"

@interface BDLocationModel()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy)   locationBlock block;

@end

@implementation BDLocationModel

+ (instancetype)shareLocationManager
{
    static dispatch_once_t onceToken;
    static BDLocationModel *model;
    
    dispatch_once(&onceToken, ^{
        model = [[self alloc]init];
    });
    return model;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 10.0f;
    }
    return self;
}

+ (void)getCurrentAddress:(locationBlock)complete
{
    [[BDLocationModel shareLocationManager] startLocation:complete];
}

- (void)startLocation:(locationBlock)complete
{
    BOOL isLocationEnabled = [CLLocationManager locationServicesEnabled];
    if (!isLocationEnabled)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:LS(@"Please_Open_Location") delegate:nil cancelButtonTitle:LS(@"Determine") otherButtonTitles:nil];
        [alertView show];
        return;
    }
    self.block = complete;
    [self.locationManager startUpdatingLocation];
}

#pragma mark -locationDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations objectAtIndex:0];
    if (![BDLocationChange isLocationOutOfChina:[loc coordinate]])
    {
        //转换后的coord
        CLLocationCoordinate2D coord = [BDLocationChange transformFromWGSToGCJ:[loc coordinate]];
        loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSString *address = @"";
        for (CLPlacemark *placemark in placemarks)
        {
            NSDictionary *test = [placemark addressDictionary];
            
            NSArray *arrray = [test objectForKey:@"FormattedAddressLines"];
            if (arrray.count>0)
            {
                for (int i=0; i<arrray.count; i++)
                {
                    address = [NSString stringWithFormat:@"%@%@",address,arrray[i]];
                }
            }
            else
            {
                address = [NSString stringWithFormat:@"%@%@%@%@%@",[test objectForKey:@"Country"],[test objectForKey:@"State"],[test objectForKey:@"City"],[test objectForKey:@"SubLocality"],[test objectForKey:@"Street"]];
            }
            
//            NSLog(@"Country--%@", [test objectForKey:@"Country"]);
//            
//            NSLog(@"State---%@", [test objectForKey:@"State"]);
//            
//            NSLog(@"SubLocality---%@", [test objectForKey:@"SubLocality"]);
//            
//            
//            NSLog(@"test---%@===%@==%@===%@====%@",test,[test objectForKey:@"Thoroughfare"],[test objectForKey:@"SubLocality"],[test objectForKey:@"FormattedAddressLines"][0],[test objectForKey:@"Street"]);
        }
        if (self.block)
        {
            self.block(address,loc,YES);
        }
    }];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *str = [error localizedDescription];;
    if (error.code == kCLErrorDenied)
    {
        str = LS(@"Refuse_Visit");
    }
    if ([error code] == kCLErrorLocationUnknown)
    {
        str = LS(@"Unable_Get_Location");
    }
    if (self.block)
    {
        self.block(str,[CLLocation new],NO);
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    if (self.block)
    {
        self.block([error localizedDescription],[CLLocation new],NO);
    }
}



@end
