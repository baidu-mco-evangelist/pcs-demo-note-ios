//
//  ViewController.m
//  PCSNote
//
//  Created by Yongmo Liang on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "BaiduOAuthSdk.h"
#import "NotesListViewController.h"

#import "SBJson.h"

#define API_KEY @"48FTB4PjV71jlCifBllSe50W"

static NSString *accessToken;


@interface ViewController () <BaiduOAuthDelegate>{
    BaiduOAuthSdk *baiduOAuth;
    NSString *fileListJson;
}

@end

@implementation ViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showListTable"])
    {
        //NotesListViewController * nlvc = [segue destinationViewController];
        //nlvc.fileListJson = fileListJson;
        
        [[segue destinationViewController] setFileListJson:fileListJson];
    }
}

// Successfully get token
-(void)onComplete:(NSString*)token
{
    NSLog(@"Complete");
    accessToken = token;
    
    // Fetch Data Show in Table View
    
    /*
    NSString *baseUrl = @"https://pcs.baidu.com/rest/2.0/pcs/quota?";
    baseUrl = [baseUrl stringByAppendingFormat:@"access_token=%@&method=%@", token, @"info"];
    */
     
    NSString *baseUrl = @"https://pcs.baidu.com/rest/2.0/pcs/file?";
    baseUrl = [baseUrl stringByAppendingFormat:@"access_token=%@&method=%@&path=/apps/云端记事本", token, @"list"];
    baseUrl = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //NSLog(@"url= %@", baseUrl);
    
    NSURL *url = [NSURL URLWithString:baseUrl];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if ([data length] > 0 && error == nil) 
        {
            fileListJson = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            
        } else if ([data length] ==0 && error == nil) {
            NSLog(@"No Data");
        } else if  (error) {
            NSLog(@"ends with error");
            NSLog(@"%@", error);
        }
        
        NSLog(@"perform segue");
        [self performSegueWithIdentifier: @"showListTable" sender: self];

    }];
    
    
    
    
    
    
    // TODO: Find usage of presentViewController
    /*
    [self presentModalViewController:nil animated:YES];
    [self presentViewController:nil animated:YES completion:^() {
        
    }];
    */
}

// Failed to get access token
-(void)onError:(NSString*)error
{
    NSLog(@"Error");
}

// OAuth Canceled
-(void)onCancel
{
    NSLog(@"Cancel");
}

- (IBAction)loginToBaiduPcs:(id)sender
{
    NSLog(@"Login to Baidu");
    [self.view addSubview:baiduOAuth.view];
    [baiduOAuth performBaiduOAuthWithApiKey:API_KEY];

}

- (BOOL) baiduAccessTokenAvailable
{
    return NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Check Acount Availability
    if ([self baiduAccessTokenAvailable]) {
        
    } else {
        
    }
    
    baiduOAuth = [[BaiduOAuthSdk alloc] init];
    baiduOAuth.mpDelegate = self;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
