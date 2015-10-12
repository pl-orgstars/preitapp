//
//  MNUserTarget.h
//  MNProximityManager
//
//  Created by Alberto Salas on 14/04/14.
//  Copyright (c) 2014 Mobiquity Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMNUserAudienceGenreMale @"M"
#define kMNUserAudienceGenreFemale @"F"

#define kMNUserAudienceEducationCollege @"CLL"
#define kMNUserAudienceEducationGradSchool @"GS"
#define kMNUserAudienceEducationNoCollege @"NCLL"

#define kMNUserAudienceEthnicityAfricanAmerican @"AA"
#define kMNUserAudienceEthnicityAsian @"AS"
#define kMNUserAudienceEthnicityCaucasian @"CC"
#define kMNUserAudienceEthnicityHispanic @"HP"

#define kMNUserAudienceIncomeUpTo30k @{@"min": @0, @"max": @30000}
#define kMNUserAudienceIncome30k60k @{@"min": @30000, @"max": @60000}
#define kMNUserAudienceIncome60k100k @{@"min": @60000, @"max": @100000}
#define kMNUserAudienceIncomeOver100k @{@"min": @100000, @"max": @NSUIntegerMax}

#define kMNUserAudienceMaritalStatusSingle @"SG"
#define kMNUserAudienceMaritalStatusMarried @"MD"

/**
 * MNUserAudience models the user profile.
 */
@interface MNUserAudience : NSObject <NSCopying>

/**
 * User Age
 * @since v1.0
 */
@property (nonatomic, strong) NSDate *birthday;

/**
 * User Genre
 * @since v1.0
 */
@property (nonatomic, strong) NSString *gender;

/**
 * User Education
 * @since v1.0
 */
@property (nonatomic, strong) NSString *education;

/**
 * User Ethnicity
 * @since v1.0
 */
@property (nonatomic, strong) NSString *ethnicity;

/**
 * User Income
 * @since v1.0
 */
@property (nonatomic, strong) NSDictionary *income;

/**
 * User Kids
 * @since v1.0
 */
@property (nonatomic, assign) NSUInteger kids;

/**
 * User Marital Status
 * @since v1.0
 */
@property (nonatomic, strong) NSString *maritalStatus;

/**
 * User preferred language as a 639-1 ISO code. If not available under that spec,
 * use the 639-2 ISO code.
 * @since v1.6
 */
@property (nonatomic, strong) NSString *language;

/**
 * An array of NSString objects representing custom tags to associate with the 
 * user.
 * @since v1.6
 */
@property (nonatomic, strong) NSArray *tags;

@end
