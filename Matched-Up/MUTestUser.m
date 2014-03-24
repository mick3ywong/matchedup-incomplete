//
//  MUTestUser.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/17/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MUTestUser.h"

@implementation MUTestUser

//section 11 Managing the User Profile - video 1 - saving test user to parse

+(void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user]; //creating new user
    
    //give username and password to newUser
    
    newUser.username = @"user1";
    newUser.password = @"password1";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            NSDictionary *profile = @{@"age": @11, @"birthday": @"08/22/2002", @"firstname" : @"BrownDog" ,@"gender": @"male", @"location" : @"Petaling Jaya, Malaysia", @"name": @"SiBrowndog"};
            //refactor this to constants later
            
            [newUser setObject:profile forKey:@"profile"];
            [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            
            {
                UIImage *profileImage = [UIImage imageNamed:@"browndog.jpg"];
                
                NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
                
                PFFile *photoFile = [PFFile fileWithData:imageData];
                
                [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                    
                     if(succeeded)
                        {
                            PFObject *photo = [PFObject objectWithClassName:kMUPhotoClassKey];
                            [photo setObject:newUser forKey:kMUPhotoUserKey];
                            
                            [photo setObject:photoFile forKey:KMUPhotoPictureKey];
                            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                            {
                                NSLog (@"Photo Saved Successfully");
                            }];
                     
                        }
                     
                 }];
                
            }];
        
        }
    }];


}

@end
