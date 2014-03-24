//
//  MUEditProfileController.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/16/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MUEditProfileController.h"

@interface MUEditProfileController ()


@property (strong, nonatomic) IBOutlet UITextView *taglineTextField;


@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;


@end

@implementation MUEditProfileController

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
    
//section 11 Managing User Profile - editViewController (video 6) - Grabbing the photo from UserProfile
    //see below saveBarButtonPressed for tagLine save

    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey]; //accessing the photo here
    
    [query whereKey:kMUPhotoUserKey equalTo:[PFUser currentUser]]; //querying using a key to user's photo key equal to the current user
    
    //execute query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if ([objects count] > 0)
         {
             PFObject *photo  = objects[0]; //photo object item 1 (0 in array index)
             PFFile *pictureFile =photo [KMUPhotoPictureKey];
             
             //get pictire
             [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
             {
                 self.profilePictureImageView.image = [UIImage imageWithData:data];
             }];
         
         }
        
    }];
    
    //update our tagLine textField
    self.taglineTextField.text =[[PFUser currentUser] objectForKey:kMUUserTagLineKey];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IB Actions EditProfileVC

//section 11 Managing User Profile video 7 Saving the tagLine textField
- (IBAction)saveBarButtonPressed:(UIBarButtonItem *)sender
{
    [[PFUser currentUser]  setObject:self.taglineTextField.text forKey:kMUUserTagLineKey];
    
    //save in background
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        //get rid of editprofileVC by popping
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
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
