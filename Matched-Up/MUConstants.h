//
//  MUConstants.h
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/15/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUConstants : NSObject

//Section 10 API Response - Creating global constants

#pragma mark - User Profile
extern NSString *const kMUUserProfileKey;
extern NSString *const kMUUserProfileNameKey;
extern NSString *const kMUUserProfileFirstNameKey;
extern NSString *const kMUUserProfileLocationKey;
extern NSString *const kMUUserProfileGenderKey;
extern NSString *const kMUUserProfileBirthdayKey;
extern NSString *const kMUUserProfileInterestedInKey;

//section 10 API Response video 4 - PicURL
extern NSString *const kMUUserProfilePictureURL;
//section 11 Adding View Controller - video 5 converting age from birthday info from FB
extern NSString *const kMUUserProfileRelationshipStatusKey;
extern NSString *const kMUUserProfileAgeKey;

//section 11 Managing Actions - video 10 - adding global constant for tagline
extern NSString *const kMUUserTagLineKey;

//section 10 API Response - video 4 - Photo Class constants
#pragma mark - Photo Class
extern NSString *const kMUPhotoClassKey;
extern NSString *const kMUPhotoUserKey;
extern NSString *const KMUPhotoPictureKey;



#pragma mark - Activity Class 
//section 11 Managing Actions - video 10

extern NSString *const kMUActivityClassKey;
extern NSString *const kMUActivityTypeKey;
extern NSString *const kMUActivityFromUserKey;
extern NSString *const kMUActivityToUserKey;
extern NSString *const KMUActivityPhotoKey;
extern NSString *const kMUActivityTypeLikeKey;
extern NSString *const kMUActivityTypeDislikeKey;


#pragma mark - Settings
//section 11 Managing User Profile - video 3

extern NSString *const kMUMenEnabledKey;
extern NSString *const kMUWomenEnabledKey;
extern NSString *const kMUSingleEnabledKey;
extern NSString *const kMUMaxAgeKey;





@end
