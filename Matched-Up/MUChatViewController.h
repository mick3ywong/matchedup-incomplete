//
//  MUChatViewController.h
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/18/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "JSMessagesViewController.h"

#import <JSMessage.h>

//section12 Chat Setup video 5 - conform to the JSMessagesViewController datasource/delegate

@interface MUChatViewController : JSMessagesViewController <JSMessagesViewDataSource,JSMessagesViewDelegate>



//section 12 Chat Setup video 4- Upon touching a cell, the user needs to be taken to the proper chatroom. We pass the entire PFObject to the chat view controller with a property

@property (strong, nonatomic) PFObject *chatRoom;

//section 12 CHat Setup video 5 - properties of the chatRoom

@property (strong, nonatomic) PFUser *withUser; //likedUser

@property (strong, nonatomic) PFUser *currentUser; //access property without using methodcall

@property (strong, nonatomic) NSTimer *chatsTimer;

@property (nonatomic) BOOL initialLoadComplete; //keep track of initialLoad of chats

@property (strong, nonatomic) NSMutableArray *chats; //lazy instantiation

@end
