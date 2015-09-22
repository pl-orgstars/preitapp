//
//  Utils.h
//  Preit
//
//  Created by kuldeep on 5/28/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#define MILE_FROM_MERTER(dist) (dist*0.00062137119)
@interface Utils : NSObject
#define is_iPhone5 [Utils isDeviceiPhone5]
#define is_iOS7 [Utils isIos7]
#define is_iOS8 [Utils isIos8]

#define is_PUSH_NOTIFICATION_ON [Utils isPushNotificationForAppIsOn]
#define is_LOCATION_SERVICE_ON [Utils isLocationServiceOn]
+(void)showAlertMesage:(NSString*)message;
+(BOOL)checkForEmptyDatas:(id)data;
+(BOOL)checkForEmptyString:(NSString*)checkString;
+(BOOL)isIos7;
+(BOOL)isIos8;
+ (BOOL)isDeviceiPhone5;
+(void)setPushNotificationForApp:(BOOL)value;
+(BOOL)isPushNotificationForAppIsOn;
+(double)calculateDistance:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t;
+(CLLocationCoordinate2D)getCLLocationCoordinate2DFromLatitude:(NSString *)latitude longitude:(NSString *)longitude;


+(void)setLocationServiceForApp:(BOOL)value;
+(BOOL)isLocationServiceOn;

@end


@interface Parking : NSObject

#define isAudioStored [Parking isParkingAudioStored]
#define isImageStored [Parking isParkingImageStored]
#define isLocationStored [Parking isParkingLocationStored]
#define isNoteStored [Parking isParkingNoteStored]

#define getNotesParking [Parking getParkingNote]
#define getLocationParking [Parking getParkingLocation]
#define getImageParking [Parking getParkingImage]
#define getAudioParking [Parking getParkingAudio]
#define getAudioNoteParking [Parking getParkingAudioNote]

#define REMOVE_PARK_LOCATION [Parking removeparkLocation]

+(void)storeParkingNote:(NSString *)string;
+(void)storeParkingLocation:(CLLocationCoordinate2D)location;
+(void)storeParkingImage:(UIImage *)image;
//+(void)storeParkingAudioLocation:(NSString *)string;
+(void)storeParkingAudioLocation:(NSString *)string note:(NSString *)note;

+(BOOL)isParkingNoteStored;
+(BOOL)isParkingLocationStored;
+(BOOL)isParkingImageStored;
+(BOOL)isParkingAudioStored;

+(NSString *)getParkingNote;
+(CLLocationCoordinate2D)getParkingLocation;
+(UIImage *)getParkingImage;
+(NSString *)getParkingAudio;
+(NSString *)getParkingAudioNote;

+(void)deleteParkingAudioLocation;

+(void)removeparkLocation;

@end