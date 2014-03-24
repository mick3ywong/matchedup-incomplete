//
//  MUMatchViewController.h
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/18/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import <UIKit/UIKit.h>

//section 12 MatchVC (video 3)
//When the user presses the view chats button, we need to show all the matches in a table. The way to do this is to create a delegate to the match view controller so it dismisses itself.
//the segue to matchVC is modal so when you dismiss the VC it will go back to HomeVC (when keepSearching button is pressed) - so instead , we need to have a protocol on the UIViewController delegate to dismiss the matchVC(current VC) and send a message to homeVC (to transition from matchVC)
@protocol MUMatchViewControllerDelegate <NSObject>

-(void)presentMatchesViewController; //a method to activitate the delegate

@end

@interface MUMatchViewController : UIViewController


//section 12 MAtchViewController (video 1)
@property (strong, nonatomic) UIImage *matchedUserImage;

//pass the photo we are currently presenting in the feed to the viewcontroller (so we dont need to download the photo again from parse/fb)
//this is matchedUserImage which is the person;s photo our user liked


//section 12 MatchVC video 3 - property for the delegate
@property (weak) id <MUMatchViewControllerDelegate> delegate;

@end
