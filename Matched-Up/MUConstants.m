//
//  MUConstants.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/15/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MUConstants.h"

@implementation MUConstants

#pragma mark - User Class
//Section 10 API Response Video 2 setting up global constants

    NSString *const kMUUserProfileKey                   = @"profile";
    NSString *const kMUUserProfileNameKey               = @"name";
    NSString *const kMUUserProfileFirstNameKey          = @"firstname";
    NSString *const kMUUserProfileLocationKey           = @"location";
    NSString *const kMUUserProfileGenderKey             = @"gender";
    NSString *const kMUUserProfileBirthdayKey           = @"birthday";
    NSString *const kMUUserProfileInterestedInKey       = @"interested_in";
    NSString *const kMUUserProfilePictureURL            = @"pictureURL";

    

//section 11 Adding ViewControllers video 5
    NSString *const kMUUserProfileRelationshipStatusKey = @"relationship_status";
    NSString *const kMUUserProfileAgeKey                = @"age";

//section 11 Adding new global constants for tagline (video 10)
    NSString *const kMUUserTagLineKey                   =@"tagline";

#pragma mark - Photo Class
//Section 10 API Response Video 4
    NSString *const kMUPhotoClassKey                    = @"Photo";
    NSString *const kMUPhotoUserKey                     = @"user";
    NSString *const KMUPhotoPictureKey                  = @"image";

#pragma mark - Activity Class
    NSString *const kMUActivityClassKey                 = @"Activity";
    NSString *const kMUActivityTypeKey                  = @"type";
    NSString *const kMUActivityFromUserKey              = @"fromUser";
    NSString *const kMUActivityToUserKey                = @"toUser";
    NSString *const KMUActivityPhotoKey                 = @"photo";
    NSString *const kMUActivityTypeLikeKey              = @"like";
    NSString *const kMUActivityTypeDislikeKey           = @"dislike";

//section 11 Managing User Profile video 3
#pragma mark - Settings 
    NSString *const kMUMenEnabledKey                    = @"men";
    NSString *const kMUWomenEnabledKey                  = @"women";
    NSString *const kMUSingleEnabledKey                 = @"single";
    NSString *const kMUMaxAgeKey                        = @"ageMax";


@end
