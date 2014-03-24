//
//  MUProfileViewController.h
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/16/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUProfileViewController : UIViewController

//section 11 - Managing the User Profile - video 2 - when user taps on info segue to user Profile VC

@property (strong, nonatomic) PFObject *photo;

//declaring this property here because this instance / class may be a reference to another class

@end
