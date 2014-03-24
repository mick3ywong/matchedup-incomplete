//
//  MUSettingsViewController.m
//  Matched-Up
//
//  Created by Mike Siew Choong Wong on 3/16/14.
//  Copyright (c) 2014 mickeywong. All rights reserved.
//

#import "MUSettingsViewController.h"

@interface MUSettingsViewController ()

@property (strong, nonatomic) IBOutlet UISlider *ageSlider;

@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *singlesOnlySwitch;

@property (strong, nonatomic) IBOutlet UIButton *logOutButton;

@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation MUSettingsViewController

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
    
//section 11 Managing User Profile (video 4) setting up the SettingsVC IB
    
    self.ageSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kMUMaxAgeKey];
    
    self.menSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUMenEnabledKey];
    
    self.womenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUWomenEnabledKey];
    
    self.singlesOnlySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUSingleEnabledKey];
    
    
    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];

    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.singlesOnlySwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //converting the slider age to a number on the label (setup UI)
    self.ageLabel.text = [ NSString stringWithFormat:@"%i", (int)self.ageSlider.value];

    //you have to implement the method valueChanged:

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions SettingsVC
- (IBAction)logoutButtonPressed:(UIButton *)sender
{
    //section 11 Managing User Profile - logging out (video 8)
    
    [PFUser logOut]; //but once logged out we want the user to be redirected to the login page so we go back to rootViewController which is where we started from
    [self.navigationController popToRootViewControllerAnimated:YES ];
    
}

- (IBAction)editProfileButtonPressed:(UIButton *)sender
{
    
    
    
}


#pragma mark - helper methods

//section 11 Managing User Profile Video 5 - valueChanged method from UI
//basically saving / persisting our user preferences

-(void)valueChanged:(id)sender
{
    if (sender == self.ageSlider)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:self.ageSlider.value forKey:kMUMaxAgeKey];
        
        self.ageLabel.text = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
        
    }

    else if (sender == self.menSwitch)
    {
    
        [[NSUserDefaults standardUserDefaults] setBool:self.menSwitch.isOn forKey:kMUMenEnabledKey];
    
    }
        
    else if (sender == self.womenSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.womenSwitch.isOn forKey:kMUWomenEnabledKey];
    
    }
    
    else if (sender == self.singlesOnlySwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.singlesOnlySwitch.isOn forKey:kMUSingleEnabledKey];
    
    }
    
    //persist and sync
    [[NSUserDefaults standardUserDefaults] synchronize ];
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
