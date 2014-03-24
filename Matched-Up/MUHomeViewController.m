//
//  MUHomeViewController.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/16/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MUHomeViewController.h"

//section 11 Managing User Profile - video 1
#import "MUTestUser.h" //we need to implement the test user here

//section 11 Managing User Profile - video 2
#import "MUProfileViewController.h"

//section 12 MatchViewController video1
#import "MUMatchViewController.h"



@interface MUHomeViewController () <MUMatchViewControllerDelegate>
//section 12 MatchVC (video 3) using delegate to pop matchVC back to homeVC when viewChatButton is pressed
//other class do not need to know about this protocol which is only for MatchVC to HomeVC (also the import matchVC.h is in the .m here) so it's better done here


//section 11 Adding The ViewControllers Video 2
//none of the other classes need to know we have chat button / like button etc so we can put our properties here in the .m instead of the .h

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *taglineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;


//section 11 AddingVC - video 6
//query a bunch of photos our user wants to see or wants to know more
@property (strong,nonatomic) NSArray *photos; //store all the photos our user wants to see
@property (nonatomic) int currentPhotoIndex; //index the multiple photos our user sees from beginning


//section 11 Managing Actions - video 1 downloading photo from Parse
@property (strong,nonatomic) PFObject *photo; //download current image / photo

//section 11 Managing Actions (video4) saving a like (clicking the likeButton)
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;
@property (strong, nonatomic) NSMutableArray *activities; //keep track of the activities like who user like / dislike)


@end

@implementation MUHomeViewController

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
    
    //section 11 Managing the User Profile - adding a test user (video1)
    
    [MUTestUser saveTestUserToParse];
    
    
    
    
    //section 11 AddingVC - video 6
    //we do not want the user to like / dislike button immediately until we download the photo only the user can interact
    
   // self.likeButton.enabled = NO;
   // self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    //section 11 video 11 - refactoring of global constants with @"xxx" to kMUxxxxxx
    
    PFQuery *query = [PFQuery queryWithClassName:kMUPhotoClassKey];
    
    //section 11 Managing the User Profile - adding a test user (video1)
    [query whereKey:kMUPhotoUserKey notEqualTo:[PFUser currentUser]];
    
    //additional constraint because we also want another profile - test profile
    
    
    [query includeKey:kMUPhotoUserKey]; //includekey - when we download photo we will download all the other relevant info of the user of the photo - includeKey of "user"
    

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            self.photos = objects; //we want to save photos as objects (since returning NSArray *objects)
            
            //section 11 Managing Actions (video 1) - why here? getting our array of photos ...we dont want to call this before the array is called or grab (after we grab the self.photos = objects from parse)
            [self queryForCurrentPhotoIndex];
            
            //section 11 Managing Actions (Video 2) updating other labels in our MUHomeVC
            [self updateView];
            
        }
        else NSLog (@"%@", error);
    }];
    
    //do additional code
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//section 11 Managing the User Profile (video 2) preparing segue for infoButton pressed
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"])
    {
        MUProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
    
    }
    //section 12 MatchViewContorller (video 1) - pass the photo from current homeVC to matchVC
    else if ([segue.identifier isEqualToString:@"homeToMatchSegue"])
    {
        MUMatchViewController *matchVC = segue.destinationViewController;
        
        matchVC.matchedUserImage = self.photoImageView.image;
        
        //section 12 MatchVC (video3) - implementing the delegate method
        matchVC.delegate = self;
    }

}





#pragma mark - IBActions

//section 11 - Adding the VCs (video 2) Home View Controller

- (IBAction)chatBarButtonItemPressed:(UIBarButtonItem *)sender
{
    
}

- (IBAction)settingsBarButtonItemPressed:(UIBarButtonItem *)sender
{
   
}

- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkLike]; //section 11 Managing Actions (video 8) implementing like /dislike helper methods
    
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    
    [self checkDislike]; //section 11 Managing Actions (video 8)
    //**Also very important when testing whether this works...you have to on the comment mode for the self.likeButton.enabled = NO; and self.disLikeButton.enabled = NO (you can refactor to make it dynamic later on)
}

- (IBAction)infoButtonPressed:(UIButton *)sender
{
//section 11 managing user profile (video 2) segue from info button pressed to profileVC

    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];

    //then you need to update segueway with a prepareForSegue method
}


#pragma mark - Helper Methods
//section 11 - Managing Actions - video 1 (create a method to query for the current photo index which will store the data for the image we want to display for the user) (downloading the photo)

-(void)queryForCurrentPhotoIndex
{

    if ([self.photos count] > 0) //photo array must be more than 0
    {
        self.photo = self.photos[self.currentPhotoIndex]; // photos = array , photo = PFObject, we set our currentphoto
        
        //now can access the value for the key image for it to get back to PFFile
        PFFile *file = self.photo [KMUPhotoPictureKey]; //do the constants later in refactor
        
        //download the file
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
            {
                if (!error) {
                                UIImage *image = [UIImage imageWithData:data];
                                self.photoImageView.image = image;
                            }
                else NSLog (@"%@", error);
            }];
    
    //section 11 Managing Actions (video 9) query for current Likes and Dislikes
        
        PFQuery *queryForLike = [PFQuery queryWithClassName:kMUActivityClassKey];
        [queryForLike whereKey:kMUActivityTypeKey equalTo:kMUActivityTypeLikeKey];
        [queryForLike whereKey:KMUActivityPhotoKey equalTo:self.photo];
        [queryForLike whereKey:kMUActivityFromUserKey equalTo:[PFUser currentUser]];
        
        
        //dislike
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kMUActivityClassKey];
        [queryForDislike whereKey:kMUActivityTypeKey equalTo:kMUActivityTypeDislikeKey];
        [queryForDislike whereKey:KMUActivityPhotoKey equalTo:self.photo];
        [queryForDislike whereKey:kMUActivityFromUserKey equalTo:[PFUser currentUser]];
        
        //this is where you run them together
        
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike,queryForDislike]];
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
            
            if (!error)
                {
                    self.activities = [objects mutableCopy];
                    if ([self.activities count] == 0)
                        {
                            self.isLikedByCurrentUser = NO;
                            self.isDislikedByCurrentUser = NO;
                    
                        }
                    else
                        {
                            PFObject *activity = self.activities[0]; //hardcoded for now Section 11 vid 9
                            
                            if ([activity[kMUActivityTypeKey] isEqualToString:kMUActivityTypeLikeKey])
                            {
                                self.isLikedByCurrentUser = YES;
                                self.isDislikedByCurrentUser = NO;
                            }
                            
                            else if ([activity [kMUActivityTypeKey] isEqualToString:kMUActivityTypeDislikeKey])
                            {
                                self.isLikedByCurrentUser = NO;
                                self.isDislikedByCurrentUser = YES;
                                
                              
                            }
                            
                            else
                            {
                                //Some other type of activity - *hint* you could use for comments or something like that
                            }
                        }
                    //enabled our like/dislike buttons because only here only we know they have liked/disliked
                    
                    self.likeButton.enabled = YES;
                    self.dislikeButton.enabled = YES;
                    
                    //section 11 Managing User Profile Video 2 (enabling the infoButton)
                    self.infoButton.enabled = YES;
                }
            
            
        }];
    }


}

//section 11 - Managing Actions - video 2 - update the labels in the view with user profile details from the photo info (because we already query includeKey @"user" and before that queryWithClassName @"Photo"

-(void)updateView
{
    self.firstNameLabel.text = self.photo[kMUPhotoUserKey][kMUUserProfileKey][kMUUserProfileFirstNameKey];
    
    //accessing the first name through user profile details through the photo info (using the key) (see query includeKey above at viewDidLoad)
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo [kMUPhotoUserKey][kMUUserProfileKey][kMUUserProfileAgeKey]];
    
    self.taglineLabel.text =self.photo [kMUPhotoUserKey][kMUUserTagLineKey];

}

//section 11 - Managing Actions - video 3 - loading the next photo (user wants to see other photo)

-(void)setupNextPhoto
{

    if (self.currentPhotoIndex +1 < self.photos.count)
    {
        self.currentPhotoIndex ++;
        [self queryForCurrentPhotoIndex];
    
        //Our photo index is increased by 1 to show that we want to move to the next photo, then we query Parse for the new index. If there are no more photos we show an alert to the user so they know why no photos are showing.
    }
    
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No More Users to View" message:@"Check back later for more people!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
    
    }
}   //remember to call this method


//section 11 - Managing Actions - video 4 (save a like)
-(void)saveLike
{
    PFObject *likeActivity = [PFObject objectWithClassName:kMUActivityClassKey]; //capital means class
    
    //set up keyValue Pairs
    [likeActivity setObject:kMUActivityTypeLikeKey forKey:kMUActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kMUActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kMUPhotoUserKey] forKey:kMUActivityToUserKey];
    [likeActivity setObject:self.photo  forKey:KMUActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        
        //section 12 Chat Prep (checking For Other Users who like the photo) implementation from helper method (video 2)
        [self checkForPhotoUsersLike]; //if yes...it will create chatroom ..etc etc
        
        //from helper method since you already done with the current photo...(to like/dislike)
        [self setupNextPhoto];
    }];


}//still you need call this method


//section 11 - Managing Actions - video 5 (save a dislike)
-(void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kMUActivityClassKey];
    [dislikeActivity setObject:kMUActivityTypeDislikeKey forKey:kMUActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kMUActivityFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kMUPhotoUserKey] forKey:kMUActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:KMUActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        [self.activities addObject:dislikeActivity];
        
        [self setupNextPhoto];
    }];


}


//section 11 Managing Actions - video 6 (check whether we have liked or disliked the photo before)
-(void)checkLike
{
    
//We don't want to keep viewing photos that we already liked. So we setup the next photo if the current one is already liked. We delete the activity if the photo has been disliked. Only if the photo has not been neither liked nor disliked do we save the like.
    
    
    if (self.isLikedByCurrentUser)
    {
        [self setupNextPhoto]; //we already liked before...go to next photo
        return;
    }
    else if (self.isDislikedByCurrentUser) //when user already disliked before now wants to like it again, we have to delete the old activity
    {
        for (PFObject *activity in self.activities)
        {
            [activity deleteInBackground];
        
        }
        [self.activities removeLastObject];
        [self saveLike]; //after we deleted to old dislike
        
        
    }
    else [self saveLike]; //other last scenario
}


//section 11 Managing Actions - video 7 (check whether we have disliked before)
-(void)checkDislike
{

    if (self.isDislikedByCurrentUser)
    {
        [self setupNextPhoto];
        return;
    }
    
    else if (self.isLikedByCurrentUser)
    {
        for (PFObject *activity in self.activities)
        {
            [activity deleteInBackground];
        }
        
        [self.activities removeLastObject];
        [self saveDislike];
    }
    
    else [self saveDislike];
        
    

}//implement methods - dont forget
//the problem after implementing these methods are they overlap...meaning you can like and dislike many times over again...on the same photo see section 11 managing actions vid 9

//section 12 - Chat Prep (video 1)
//check for Likes helper method

-(void)checkForPhotoUsersLike
{
    //create a query to through activity
    PFQuery *query =[PFQuery queryWithClassName:kMUActivityClassKey];
    
    //constraint the query only getting back the activity from the User from the photos
    [query whereKey:kMUActivityFromUserKey  equalTo:self.photo[kMUPhotoUserKey]];
    
    //additional constraint
    [query whereKey:kMUActivityToUserKey equalTo:[PFUser currentUser]]; //only getting back activity when we are involved
    
    //only checking for likes
    [query whereKey:kMUActivityTypeKey equalTo:kMUActivityTypeLikeKey];
    
    
    //run our query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if ([objects count] > 0)
        {
            //create our chatroom (when there is a like for like event)
        //section 12 - Chat Prep (video 2) after completion of creatChatRoom Helper method to execute
            [self createChatRoom];
        
        }//you need to implement checkForPhotoUsersLike in the saveLike method
    }];
    


}

//section 12 - Chat Prep (video 2 ) create Chat Room Helper Method

-(void)createChatRoom
{
   
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"Chatroom"]; //later must create global constants for CHatroom
    
    [queryForChatRoom whereKey:@"user1" equalTo:[PFUser currentUser]];
    
    //second constraint
    [queryForChatRoom whereKey:@"user2" equalTo:self.photo[kMUPhotoUserKey]]; //user2 key value pair must be equal to the user of the photo we are currently viewing
    
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:@"Chatroom"]; //this query going to check the opposite (current user can be user 1 or even user 2) getting back both ways
    
    [queryForChatRoomInverse whereKey:@"user1" equalTo:self.photo[kMUPhotoUserKey]];
    [queryForChatRoomInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    //combine the queries (orQueryWithSubqueries)
    PFQuery *combinedQueries = [PFQuery orQueryWithSubqueries:@[queryForChatRoom,queryForChatRoomInverse]];
    
    //run or query
    [combinedQueries findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if ([objects count] == 0)
        {
            //if this returns to nothing then we need to create a chatroom object
            PFObject *chatRoom =[PFObject objectWithClassName:@"Chatroom"];
            
            //setup keyvalue pair
            [chatRoom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatRoom setObject:self.photo [kMUPhotoUserKey] forKey:@"user2"]; //we needto do in inverse as well because the events could take place in either perspective ...either user1 likes user2 first OR user2 likes user1 ---both are possible scenarios
            
            //save chatRoom object
            [chatRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                //we will segue to MatchVC
                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
                
                
            }]; //dont forget to implement these methods in your create chatroom
        }
    }];
}

//section 12 MatchVC - video 3 implementing the delegate methods
#pragma mark - MUMatchViewControllerDelegate

-(void)presentMatchesViewController  //remember this method was a protocol method in Match but we delegated it here to homeVC becuase we wanna pop matchVC back to homeVC
{
    [self dismissViewControllerAnimated:NO completion:^{  //modal segue
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil]; //now update the prepareforSegue
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
