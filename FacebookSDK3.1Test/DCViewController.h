//
//  DCViewController.h
//  FacebookSDK3.1Test
//
//  Created by David Cespedes on 9/10/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *authButton;
@property (strong, nonatomic) IBOutlet UITextView *textNoteOrLink;
- (IBAction)authButtonAction:(id)sender;

@end
