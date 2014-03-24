//
//  MUMatchesViewController.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/18/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MUMatchesViewController.h"

//section 12 Chat Setup (video 4) - Selecting Chatroom
#import "MUChatViewController.h"


@interface MUMatchesViewController () <UITableViewDelegate, UITableViewDataSource> //section 12 Chat Setup (video 2)


//section 12 StoryBoard setup (matchesVC) UI - video 3
@property (strong, nonatomic) IBOutlet UITableView *tableView;


//section 12 Chat Setup Video 1 - Create a chatroom property
@property (strong, nonatomic) NSMutableArray *availableChatRooms;

@end

@implementation MUMatchesViewController

#pragma mark - Lazy Instantiation
//section 12 CHat Setup video 2

-(NSMutableArray *)availableChatRooms
{
    if(!_availableChatRooms)
    {
        _availableChatRooms = [[NSMutableArray alloc] init];
        
    }
    return _availableChatRooms;
}


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
    

//section 12 Chat Setup (video 2) setup the tableView
    
    //*remember you need toconform to UITableView datasource and delegate methods
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self updateAvailableChatrooms];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//section 12 - Chat Setup (video 4) from performSegueWithIdentifier  under didSelectRowAtIndexPath
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    MUChatViewController *chatVC = segue.destinationViewController;
    NSIndexPath *indexPath = sender;
    
    //send the user to ChatVC to availableChatRoom (which is based on the MatchesTableView] on the tapped cell (indexPath.row)
    
    chatVC.chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];


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


#pragma mark - Helper MEthods
//section 12 Chat Setup Video 1 - Update and Settng up the Chatrooms in MatchesVC

-(void)updateAvailableChatrooms
{
    PFQuery *query = [PFQuery queryWithClassName:@"Chatroom"]; //remember to change to global constants
    
    //constraint query
    [query whereKey:@"user1" equalTo:[PFUser currentUser]]; //give me back all my chatrooms and make sure than user1 is equal to current user...
    
    //create inverse
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"Chatroom"];
    [query whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    //combine the queries
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query,queryInverse]];
    
    [queryCombined includeKey:@"chat"]; //creating a chat class...and chat is going to hold each line / text for our chatroom
                              
    //access the info from chat object
    [queryCombined includeKey:@"user1"];
    [queryCombined includeKey:@"user2"]; //download the user objects and also chatroom object
                              
    //run query
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            [self.availableChatRooms removeAllObjects];
            
            self.availableChatRooms = [objects mutableCopy]; //it's an NSArray so we make it to mutable because we might add and remove chats
            
            [self.tableView reloadData];
        
        }
    }];
                              


}
//section 12 - Chat Setup (video 2) implementing the table view datasource / delegate methods like how we always do for tableView.
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.availableChatRooms count]; //return the array of chatRooms number

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
        static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];
     //access our availableChatRooms array and create an object called chatRoom from that array
    
    PFUser *likedUser;
    
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testUser1 = chatRoom [@"user1"];
    
    if ([testUser1.objectId isEqualToString:currentUser.objectId]) //in parse every object has a unique object ID
    {
        likedUser = [chatRoom objectForKey:@"user2"];
    
    }
    else
    {
        likedUser = [chatRoom objectForKey:@"user1"];
    
    }
    cell.textLabel.text =likedUser[@"profile"][@"firstname"];
    
    //section 12 Chat Setup -video 3 (display image for the liked user in our table view)
    
    //cell.imageView.image = placeHolder image (come back here when we update our image assets)
    
    //image on the tableViewcell
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //create a PFQuery for the photo and initWithClassName
    PFQuery *queryForPhoto = [[PFQuery alloc] initWithClassName:@"Photo"];
    
    //constraint query for the picture of user which current user liked
    [queryForPhoto whereKey:@"user" equalTo:likedUser];
    
    //run query - get objects if more than 0 we get PFFile for our photo (download the data of the poictureFile) and update cell's imageView with the data
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] >0)
        {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo [KMUPhotoPictureKey];
            
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }];
        
        }
    }];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
//section 12 Chat Setup (video 4) - when the user selects a cell in our tableView in matchesVC we need to present the ChatVC (it's actually a push segue)

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"matchesToChatSegue" sender:indexPath]; //go to prepareforSegue  - pass the chatroom that was selected to the ChatVC
    

}


@end
