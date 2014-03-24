//
//  MUMatchViewController.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/18/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MUMatchViewController.h"

@interface MUMatchViewController ()

//section 12 StoryBoard Setup (video 1) hooking up UI for MatchVC

@property (strong, nonatomic) IBOutlet UIImageView *matchedUserImageView;

@property (strong, nonatomic) IBOutlet UIImageView *currentUserImageView;

@property (strong, nonatomic) IBOutlet UIButton *viewChatsButton;

@property (strong, nonatomic) IBOutlet UIButton *keepSearchingButton;

@end

@implementation MUMatchViewController

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
    
//Section 12 - MatchVieWController - implementing it (video 2)
   // The match view controller first needs to query for the photo of the current user so the app can display the photo side by side with the photo passed to this view controller. Download the image and set the image view with the result data. Also set the matchedUserImageView with the image data passed from the last view controller.
    
    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey]; //give me back the photo from the query
    
    //set constraint query
    [query whereKey:kMUPhotoUserKey equalTo:[PFUser currentUser]]; //give me back only the photo for myself (user) and display side by side
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if ([objects count] > 0) //user must have a(1) photo at least
        {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[KMUPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
             {
                //get photo as data then convert
                 self.currentUserImageView.image = [UIImage imageWithData:data]; //similar to editVC
                 
                 //setup imageView for MatchUser
                 self.matchedUserImageView.image = self.matchedUserImage;
                 
                 
            }];
        
        }
    }];
    

    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

//section 12 - StoryBoard setup for MatchVC (video 1)

- (IBAction)viewChatsButtonPressed:(UIButton *)sender
{
    //When the user presses the view chats button, we need to show all the matches in a table. The way to do this is to create a delegate to the match view controller so it dismisses itself.
    
    //section 12 MatchVC (video 3)
    
    [self.delegate presentMatchesViewController]; //so we need to go back to implement the code for the delegate method
    
    
}

- (IBAction)keepSearchingButtonPressed:(UIButton *)sender
{

//section 12 MatchViewController - video 2 (dismiss the keepSearchingBUtton when pressed)
    
    [self dismissViewControllerAnimated:YES completion:nil]; //modal segue so you dont need to self.navigationVC popVC (which is a push segue)
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
