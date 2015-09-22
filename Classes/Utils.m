//
//  Utils.m
//  Preit
//
//  Created by kuldeep on 5/28/14.
//
//

#import "Utils.h"
#define PushNotification @"PushNotification"
#define LOCAL_SEVICE_AVILABLE @"LocalServiceAvailable"

@implementation Utils
+(void)showAlertMesage:(NSString*)message{
    [[[UIAlertView alloc]initWithTitle:@"PREIT" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil]show];
}
+(BOOL)checkForEmptyDatas:(id)data{
    if (data == [NSNull null] || data == nil ||
        data == NULL ||
        data == Nil ||
        [data isKindOfClass:[NSNull class]]) {
        
        return YES;
        
        
    }else{
        return NO;
        
    }
    
}

+(BOOL)checkForEmptyString:(NSString*)checkString {
    for (int i=0; i<checkString.length; i++) {
        if ([checkString characterAtIndex:i]!=' ') {
            return NO;
        }
    }
    return YES;
}
+(BOOL)isIos7{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?YES:NO;
}
+(BOOL)isIos8{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0?YES:NO;
}
+ (BOOL)isDeviceiPhone5{
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    return rect.size.height==568?YES:NO;
    
}


+(void)setPushNotificationForApp:(BOOL)value{
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    [userdefaut setBool:value forKey:PushNotification];
    [userdefaut synchronize];
}
+(BOOL)isPushNotificationForAppIsOn{
    return [[NSUserDefaults standardUserDefaults]boolForKey:PushNotification];
}
+(void)setLocationServiceForApp:(BOOL)value{
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    [userdefaut setBool:value forKey:LOCAL_SEVICE_AVILABLE];
    [userdefaut synchronize];
}
+(BOOL)isLocationServiceOn{
    return [[NSUserDefaults standardUserDefaults]boolForKey:LOCAL_SEVICE_AVILABLE];
}


+(double)calculateDistance:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t
{
    
    //    CLLocation *locA = [[CLLocation alloc] initWithLatitude:f.latitude longitude:f.longitude];
    CLLocation *locA = [[CLLocation alloc] initWithCoordinate: f altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    
    //    CLLocation *locB = [[CLLocation alloc] initWithLatitude:t.longitude longitude:t.longitude];
    CLLocation *locB = [[CLLocation alloc] initWithCoordinate: t altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    NSLog(@"distance %f",distance);
    return MILE_FROM_MERTER(distance);
}
+(CLLocationCoordinate2D)getCLLocationCoordinate2DFromLatitude:(NSString *)latitude longitude:(NSString *)longitude{
    CLLocationCoordinate2D cordinate;
    
    cordinate.latitude = latitude.floatValue;
    cordinate.longitude = longitude.floatValue;
    return cordinate;
    
}
@end

#define PARKING_NOTE @"parkingNote"
#define PARKING_LOCATION @"parkingLocation"
#define PARKING_IMAGE @"parkingImage"
#define PARKING_MAP_IMAGE @"parkingMapImage"
#define PARKING_AUDIO_LOCATION @"parkingAudioLocation"
#define PARKING_AUDIO_LOCATION_NOTE @"parkingAudioLocationNote"
@implementation Parking

+(void)storeParkingNote:(NSString *)string{
    
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    [userdefaut setObject:string forKey:PARKING_NOTE];
    [userdefaut synchronize];
}
+(void)storeParkingLocation:(CLLocationCoordinate2D)location{
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithFloat:location.longitude],@"long",[NSNumber numberWithFloat:location.latitude],@"lat", nil];
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    [userdefaut setObject:dict forKey:PARKING_LOCATION];
    [userdefaut synchronize];
}
+(void)storeParkingMapImage:(UIImage*)image{
    NSData* imageData = UIImageJPEGRepresentation(image, 1);// UIImagePNGRepresentation(image);
    NSData* myEncodedImageData = [NSKeyedArchiver archivedDataWithRootObject:imageData];
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    [userdefaut setObject:myEncodedImageData forKey:PARKING_MAP_IMAGE];
    [userdefaut synchronize];

}
+(void)storeParkingImage:(UIImage *)image{
    NSData* imageData = UIImageJPEGRepresentation(image, 1);// UIImagePNGRepresentation(image);
    NSData* myEncodedImageData = [NSKeyedArchiver archivedDataWithRootObject:imageData];
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    [userdefaut setObject:myEncodedImageData forKey:PARKING_IMAGE];
    [userdefaut synchronize];

}

+(void)storeParkingAudioLocation:(NSString *)string note:(NSString *)note{
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    [userdefaut setObject:string forKey:PARKING_AUDIO_LOCATION];
    
    [userdefaut setObject:note forKey:PARKING_AUDIO_LOCATION_NOTE];
    
    [userdefaut synchronize];
}
+(void)deleteParkingAudioLocation{
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    [userdefaut removeObjectForKey:PARKING_AUDIO_LOCATION];
    
    [userdefaut removeObjectForKey:PARKING_AUDIO_LOCATION_NOTE];

    [userdefaut synchronize];
}

+(BOOL)isParkingNoteStored{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PARKING_NOTE];
}
+(BOOL)isParkingLocationStored{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PARKING_LOCATION];
}
+(BOOL)isParkingMapImageStored{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PARKING_MAP_IMAGE];
}
+(BOOL)isParkingImageStored{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PARKING_IMAGE];
}
+(BOOL)isParkingAudioStored{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PARKING_AUDIO_LOCATION];
}
+(NSString *)getParkingAudioNote{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PARKING_AUDIO_LOCATION_NOTE];
}

+(NSString *)getParkingNote{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PARKING_NOTE];
}
+(CLLocationCoordinate2D)getParkingLocation{
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userdefaut objectForKey:PARKING_LOCATION];
    return CLLocationCoordinate2DMake([[dict objectForKey:@"lat"]floatValue], [[dict objectForKey:@"long"]floatValue]);
    
}
+(UIImage*)getMapImage{
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    NSData* myEncodedImageData = [userdefaut objectForKey:PARKING_MAP_IMAGE];
    NSData *imageData = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedImageData];
    return [UIImage imageWithData:imageData];
}
+(UIImage *)getParkingImage{
    NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    NSData* myEncodedImageData = [userdefaut objectForKey:PARKING_IMAGE];
    NSData *imageData = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedImageData];
    return [UIImage imageWithData:imageData];
}
+(NSString *)getParkingAudio{
    return [[NSUserDefaults standardUserDefaults]objectForKey:PARKING_AUDIO_LOCATION];
}

+(void)removeparkLocation{
     NSUserDefaults *userdefaut = [NSUserDefaults standardUserDefaults];
    [userdefaut removeObjectForKey:PARKING_LOCATION];
    [userdefaut synchronize];
}

@end
