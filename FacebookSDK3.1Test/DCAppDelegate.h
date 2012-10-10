//
//  DCAppDelegate.h
//  FacebookSDK3.1Test
//
//  Created by David Cespedes on 9/10/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;

@interface DCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

@end
