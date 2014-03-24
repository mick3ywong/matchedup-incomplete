//
//  MUProfileViewController.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/16/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MUProfileViewController.h"

@interface MUProfileViewController ()


@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UILabel *taglineLabel;

@end

@implementation MUProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //section 11 Managing the User Profile (video 2)
    
    PFFile *pictureFile = self.photo[KMUPhotoPictureKey];
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        self.profilePictureImageView.image = [UIImage imageWithData:data];
        
        PFUser *user = self.photo[kMUPhotoUserKey];
        self.locationLabel.text = user[kMUUserProfileLocationKey];
        self.ageLabel.text = [NSString stringWithFormat:@"%@", user[kMUUserProfileKey][kMUUserProfileAgeKey]];
        self.statusLabel.text = user [kMUUserProfileKey][kMUUserProfileRelationshipStatusKey];
        self.taglineLabel.text = user [kMUUserTagLineKey];
        
        //call the segue when clicked (tapped) on info buttonPressed 
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
