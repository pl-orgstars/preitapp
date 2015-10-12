//
//  MNRegionNotification.h
//  MNProximityManager
//
//  Created by Alberto Salas on 23/01/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * MNNotificationLocalizedData models the localized data of a notification
 */
@interface MNNotificationLocalizedData : NSObject

/**
 * Notification title
 * @since v1.0 and later
 */
@property (nonatomic, strong, readonly) NSString *title;

/**
 * Notification text
 * @since v1.0 and later
 */
@property (nonatomic, strong, readonly) NSString *text;

@end




/**
 * MNRegionNotification models a notification.
 *
 * @note Equality based on the identifier
 */
@interface MNNotification : NSObject

/**
 * Notification identifier
 * @since v1.0 and later
 */
@property (nonatomic, strong, readonly) NSString *identifier;

/**
 * Notification sound
 * @since v2.0 and later
 */
@property (nonatomic, readonly) BOOL sound;

/**
 * Notification URL Type
 * @since v2.0 and later
 */
@property (nonatomic, strong, readonly) NSString *urlType;

/**
 * Notification URL
 * @since v2.0 and later
 */
@property (nonatomic, strong, readonly) NSString *url;

/**
 * Notification Frequency
 * @since v2.1 and later
 */
@property (nonatomic, strong, readonly) NSString *frequency;

/**
* Notification display type
* @since v1.6
*/
@property (nonatomic, strong, readonly) NSString *displayType;

/**
 * Notification data
 * @discussion Keys are languages as NSString, values are <MNNotificationLocalizedData> instances
 * @since v1.0 and later
 */
@property (nonatomic, strong, readonly) NSDictionary *localizedData;

/**
 * Notification localized data for a locale
 * @param locale Desired locale
 * @return Localized data for the passed locale or null
 * @since v1.0 and later
 */
- (MNNotificationLocalizedData *)localizedDataForLocale:(NSLocale *)locale;

/**
 * Notification localized data for the default locale
 * @return Localized data for the default locale
 * @since v1.0 and later
 */
- (MNNotificationLocalizedData *)localizedDataForDefaultLocale;

@end
