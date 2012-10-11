//
//  ShareViewController.h
//  FacebookSDK3.1Test
//
//  Created by David Cespedes on 11/10/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ShareViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

@end
