//
//  DCViewController.m
//  FacebookSDK3.1Test
//
//  Created by David Cespedes on 9/10/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "DCViewController.h"
#import "DCAppDelegate.h"
#import "ShareViewController.h"

@interface DCViewController ()

@end

@implementation DCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    DCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)authButtonAction:(id)sender {
    DCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}


- (IBAction)publishButtonAction:(id)sender {
    //UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //ShareViewController*  viewController = [storyboard instantiateViewControllerWithIdentifier:@"ShareViewController"];
    
    ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
        self.publishButton.hidden = NO;
        [self.textNoteOrLink setText:[NSString stringWithFormat:@"%@",FBSession.activeSession.accessToken]];
    } else {
        [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
        self.publishButton.hidden = YES;
        [self.textNoteOrLink setText:[NSString stringWithFormat:@"Please, Login!"]];
    }
}

@end
