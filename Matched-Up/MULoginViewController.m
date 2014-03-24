//
//  MULoginViewController.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/15/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MULoginViewController.h"

@interface MULoginViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//section 10 API Response video 5 - Saving image
@property (strong, nonatomic) NSMutableData *imageData;

@end

@implementation MULoginViewController

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
    
    //section 10 LoginFunctionality - Activity Indicator
    //we want to set the activity Indicator to be hidden until it is button pressed (see IBAction Button Pressed below or pragma mark IBACtion)
    
    self.activityIndicator.hidden = YES;
    
}

//section 10 - API Response (Video 8) When User already logged in
- (void)viewDidAppear:(BOOL)animated
{

    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [self updateUserInformation];
        
        //section 11 - Adding View Controllers - Refactoring video 5
        [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
    
    }

}
    

    


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - IBActions
//section 10 - Final Project: Matched Up Vid 1
- (IBAction)loginButtonPressed:(UIButton *)sender
{

    //section 10 - Login Functionality  video 1 unhide activity indicator when button is pressed
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    
    //section 10 - Login Functionality - Permissions Array
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    
    //naming conventions from facebook extended profile properties under permissions to login with facebook https://developers.facebook.com/docs/facebook-login/permissions/
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error)
    {
        [self.activityIndicator stopAnimating]; //you want it to stop animating once it is pressed
        self.activityIndicator.hidden = YES;
        
        if (!user)
            
            {
            
            if (!error)
            
                {  //this means if there's / dont get a user back or no error means you have to use facebook to login ...user has probably pressed cancel with login in with FB
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"The Facebook Login Was Cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    [alertView show];
                }
            
            
            else
                {
                
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    [alertView show];
                
                }
            }
        
        else
            {
                
                [self updateUserInformation]; //helper method evaluate and update user Info
                [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self]; //section 11 Adding VC Video 5
        
        
            }
            
       
        
        
    }];
    

}


#pragma mark - Helper Method
//section 10 - Login Functionality - video 3

-(void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error)
            {   //section 10 API Response video 1
                //NSLog (@"%@", result);
                
                NSDictionary *userDictionary = (NSDictionary *)result;  //access by using key value through the NSDictionary
    
                
                
                //section 10 API Response video 4 - create URL
                NSString *facebookID = userDictionary[@"id"];
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",facebookID]];
                
                
                
                NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
                
        
                //section 10 API Response video 3 - Replacing with global constants
                
                if (userDictionary[@"name"])
                {
                   // userProfile[@"name"] = userDictionary [@"name"];
                    userProfile[kMUUserProfileNameKey] = userDictionary [@"name"];
                }
                
                if (userDictionary [@"first_name"])
                {
                    userProfile[kMUUserProfileFirstNameKey] = userDictionary [@"first_name"];
                }
                
                if (userDictionary [@"location"][@"name"])
                {
                    userProfile[kMUUserProfileLocationKey] = userDictionary [@"location"][@"name"];
                }
                
                if (userDictionary [@"gender"])
                {
                    userProfile[kMUUserProfileGenderKey] = userDictionary [@"gender"];
                }
                
                if (userDictionary [@"birthday"])
                {
                    userProfile[kMUUserProfileBirthdayKey] = userDictionary [@"birthday"];
                
                //section 11 Adding ViewControllers (video 5) -convert age from Birthday grabbed from FB
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterShortStyle];
                    NSDate *date = [formatter dateFromString:userDictionary[@"birthday"]];
                    NSDate *now = [NSDate date];
                    NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                    
                    int age = seconds / 31536000; //3153600 number of seconds per year
                    
                    userProfile[kMUUserProfileAgeKey] = @(age);
                    
                    
                }
                
                if (userDictionary [@"interested_in"])
                {
                    userProfile [kMUUserProfileInterestedInKey] = userDictionary [@"interested_in"];
                    
                }
                
                //section 11 Adding ViewControllers (video 5) - grab age from birthday from FB and also relationship status
                if (userDictionary [@"relationship_status"])
                {
                    userProfile [kMUUserProfileRelationshipStatusKey] = userDictionary [@"relationship_status"];
                
                }
                

                
                
                //section 10 API Response (Create / save url for pic grabbed from fb)
                if ([pictureURL absoluteString])
                {
                    userProfile [kMUUserProfilePictureURL] = [pictureURL absoluteString];
                
                }
                
                //[[PFUser currentUser] setObject:userProfile forKey:@"profile"];
                [[PFUser currentUser] setObject:userProfile forKey:kMUUserProfileKey];
                
                [[PFUser currentUser] saveInBackground];
                
                
                //section 10 API Response video 7 (from helper method connections) - execute helper method below requestImage (video 6)
                [self requestImage];
                
            }
        
    
        else
            {
                
                NSLog (@"Error in FaceBook request %@", error);
            
            }
        //call the method above
    }];


}

//section 10 API Response Video 5 - Saving a PFFile to Parse (saving the FB Pic from FB Url)
-(void)uploadPFFileToParse:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    if (!imageData)
    {
        NSLog (@"imageData was not found");
        return;
    }
    
    PFFile *photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
        {
            PFObject *photo  = [PFObject objectWithClassName:kMUPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kMUPhotoUserKey];
            [photo setObject:photoFile forKey:KMUPhotoPictureKey];
            
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               
                NSLog (@"Photo Save Successfully");
            }];
        
        }
        
    }];
}


//section 10 API Response -  Request to Upload Image from FB (video 6)
-(void)requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey];
    [query whereKey:kMUPhotoUserKey equalTo:[PFUser currentUser]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0)
        {
            PFUser *user = [PFUser currentUser];
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureURL = [NSURL URLWithString:user[kMUUserProfileKey][kMUUserProfilePictureURL]];
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
            
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self ];
            
                if (!urlConnection)
                    {
                        NSLog (@"Failed to download picture");
                    }

        }
    }];


}

//section 10 connecting to URL video 7
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
    

}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];

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
