//
//  MUChatViewController.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/18/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MUChatViewController.h"
#import <JSMessagesViewController/JSMessage.h>

@interface MUChatViewController ()

@end

@implementation MUChatViewController

//section 12 Chat Setup (Video 5) Lazy instantiation of NSMutableArray *chats (no of chats)

-(NSMutableArray *)chats
{
    if (!_chats)
    {
        
        _chats = [[NSMutableArray alloc] init ];
        
    }
        
        return _chats;

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

//Section 12 - Implementing Chats (Video 1)
    //implementing the delegate (but it is self) - check github documentation on jsmessage
    
    self.delegate = self;
    self.dataSource = self;
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    
    self.messageInputView.textView.placeHolder = @"New Message";
    [self setBackgroundColor:[UIColor grayColor]];
    
    self.currentUser = [PFUser currentUser];
    
    //set a test user
    PFUser *testUser1 = self.chatRoom[@"user1"];
    
    if ([testUser1.objectId isEqual:self.currentUser.objectId])
    {
        self.withUser = self.chatRoom[@"user2"];
    
    }
    else
    {
        
    self.withUser = self.chatRoom[@"user1"];
    }
    self.title = self.withUser[@"profile"][@"firstname"];
    
    self.initialLoadComplete = NO; //havent done a load of our chats
    
    
//Section 12 Check/Refresh Chats (video 2) - from helper method checkForNewChats
    
    [self checkForNewChats];
    
//We want to refresh the chats every 15 seconds. That will check parse and update our table if there are new chats. Set up the timer in your viewDidLoad method.
    
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];

//you need to turn off the timer when viewDidDisappear (see below)
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//section 12 Check/Refresh Chats (video 2)
//We only want to check every 15 seconds when the user is on this view. When they leave this view, we need to stop the timer.

-(void)viewDidDisappear:(BOOL)animated
{

    [self.chatsTimer invalidate];
    
    self.chatsTimer = nil; //dealloc
    
}


#pragma mark - Implement TableView DataSource Methods

//section 12 Implementing Chats (Video 1)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chats count]; //show our existing chats in a table view

}

#pragma mark - TableView Delegate
//section 12 Message View Delegate DidSend Text (video 2) when we press the send button

-(void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
 //JSMessages will create a send button for us we just need to code the mechanics
    
 
    if (text.length != 0)
    {
        PFObject *chat = [PFObject objectWithClassName:@"Chat"];
        
        
        [chat setObject:self.chatRoom forKey:@"chatroom"];
        
        
        
        //from me or other user
        
        [chat setObject:[PFUser currentUser] forKey:@"fromUser"];
        
        [chat setObject:self.withUser forKey:@"toUser"];
        
        [chat setObject:text forKey:@"text"];
        
        //save chat
        
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            NSLog (@"save complete");
            
            [self.chats addObject:chat];
            
            [self.chats addObject:[[JSMessage alloc] initWithText:text sender:sender date:date]];
            
            //play a sound
            [JSMessageSoundEffect playMessageSentSound];
            [self.tableView reloadData];
            
            [self finishSend]; //animate textView
            
            [self scrollToBottomAnimated:YES];
        }];
    
    }

   /*
    JSMessage *chat = [[JSMessage alloc] initWithText:text sender:sender date:date];
    [self.chats addObject:chat];
    [JSMessageSoundEffect playMessageSentSound];
    [self.tableView reloadData];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
 */
}


//Section 12 Implementing the Chat (video 3) check out documentation of JSMessages for delegate methods

-(JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat =self.chats[indexPath.row];
    
    PFUser *testFromUser = chat[@"fromUser"];
    
    if([testFromUser.objectId isEqual:self.currentUser.objectId])
    {
        return JSBubbleMessageTypeOutgoing;
    
    }
    else return JSBubbleMessageTypeIncoming;
}


//Section 12 Implementingthe Chat (video 4) see documentation of JSMessages

-(UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat =self.chats[indexPath.row];
    
    PFUser *testFromUser = chat[@"fromUser"];
    
    if ([testFromUser.objectId isEqual:self.currentUser.objectId])
    {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleGreenColor]];
    
    }
    else
    {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
}

//Section 12 IMplement Chat (video 5) TimeStamp - see documentation of JSMessages

//new method changed (not required method)


-(BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row %3 == 0)
    {
        return YES;
    }
    return NO;
}

-(JSMessageInputViewStyle)inputViewStyle //required method - see docs (delegate)
{
    return JSMessageInputViewStyleFlat;
}


-(UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender //required method under datasource
{
    return nil;
}



-(id<JSMessageData>)messageForRowAtIndexPath:(NSIndexPath *)indexPath //required method
{
    PFObject *chat = self.chats [indexPath.row];
    JSMessage *message = chat [@"text"];
    return message;
    
    //JSMessage *chat = self.chats [indexPath.row];
    //return chat;
    
    //return [self.chats objectAtIndex:indexPath.row];
}





#pragma mark Delegate / DataSource Methods (Optional)


//Section 12 IMplementing Chats -(Video 6) Message ViewDelegate Optional Methods
-(void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if([cell messageType] == JSBubbleMessageTypeOutgoing)
    {
     

        cell.bubbleView.textView.textColor = [UIColor grayColor];
    }
}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling

{
    
    return YES;
    
}





#pragma mark - helper methods

//section 12 Check/Refresh Chats (video 1)

-(void)checkForNewChats  //check for new chats - query parse if there are new chats if not do nothing
{

    int oldChatCount = [self.chats count]; //the current array of chats
    
    PFQuery *queryForChats = [PFQuery queryWithClassName:@"Chat"];
    
    [queryForChats whereKey:@"chatroom" equalTo:self.chatRoom];
    
    [queryForChats orderByAscending:@"createdAt"]; //get our chats from the order they were created - newest to oldest (*important you dont this ...you chat will come back in random order)
    
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
   
     {
            if (!error)
                {
                    if (self.initialLoadComplete == NO || oldChatCount != [objects count])
                     
                    {
                        self.chats = [objects mutableCopy];
                        [self.tableView reloadData];
                        
                        
                        if (self.initialLoadComplete == YES)
                            {
                                [JSMessageSoundEffect playMessageReceivedSound];
                            }
                            
                         self.initialLoadComplete = YES;
                        [self scrollToBottomAnimated:YES];
                        
                    }//implement this method on viewDidLoad as we wanna check for new chats
                
                
                }
            
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
