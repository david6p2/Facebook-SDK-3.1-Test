//
//  ShareViewController.m
//  FacebookSDK3.1Test
//
//  Created by David Cespedes on 11/10/12.
//  Copyright (c) 2012 LSR Marketing Service. All rights reserved.
//

#import "ShareViewController.h"
NSString *const kPlaceholderPostMessage = @"Say something about this...";

@interface ShareViewController () <UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *postNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@end

@implementation ShareViewController

@synthesize postMessageTextView = _postMessageTextView;
@synthesize postImageView = _postImageView;
@synthesize postNameLabel = _postNameLabel;
@synthesize postCaptionLabel = _postCaptionLabel;
@synthesize postDescriptionLabel = _postDescriptionLabel;

@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.postParams =
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:
         @"https://developers.facebook.com/ios", @"link",
         @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
         @"Facebook SDK for iOS", @"name",
         @"Build great social apps and get more installs.", @"caption",
         @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
         nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Show placeholder text
    [self resetPostMessage];
    // Set up the post information, hard-coded for this sample
    self.postNameLabel.text = [self.postParams objectForKey:@"name"];
    self.postCaptionLabel.text = [self.postParams
                                  objectForKey:@"caption"];
    [self.postCaptionLabel sizeToFit];
    self.postDescriptionLabel.text = [self.postParams
                                      objectForKey:@"description"];
    [self.postDescriptionLabel sizeToFit];
    
    // Kick off loading of image data asynchronously so as not
    // to block the UI.
    self.imageData = [[NSMutableData alloc] init];
    NSURLRequest *imageRequest = [NSURLRequest
                                  requestWithURL:
                                  [NSURL URLWithString:
                                   [self.postParams objectForKey:@"picture"]]];
    self.imageConnection = [[NSURLConnection alloc] initWithRequest:
                            imageRequest delegate:self];
}
- (void)viewDidUnload{
    if (self.imageConnection) {
        [self.imageConnection cancel];
        self.imageConnection = nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButtonAction:(id)sender {
    [[self presentingViewController]
     dismissViewControllerAnimated:YES completion:^{
         
     }];
}
- (IBAction)shareButtonAction:(id)sender {
    // Hide keyboard if showing when button clicked
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }
    // Add user message parameter if user filled it in
    if (![self.postMessageTextView.text
          isEqualToString:kPlaceholderPostMessage] &&
        ![self.postMessageTextView.text isEqualToString:@""]) {
        [self.postParams setObject:self.postMessageTextView.text
                            forKey:@"message"];
    }
    
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         reauthorizeWithPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self publishStory];
             }
         }];
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
}

- (void)publishStory
{
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
             NSLog(@"%@",[error description]);
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}

- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor lightGrayColor];
}

/*
 * A simple way to dismiss the message text view:
 * whenever the user clicks outside the view.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Clear the message text when the user starts editing
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Reset to placeholder text if the user is done
    // editing and no message has been entered.
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self presentingViewController]
     dismissViewControllerAnimated:YES completion:^{
         
     }];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
    self.postImageView.image = [UIImage imageWithData:
                                [NSData dataWithData:self.imageData]];
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    self.imageConnection = nil;
    self.imageData = nil;
}

@end
