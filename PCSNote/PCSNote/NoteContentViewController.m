//
//  NoteContentViewController.m
//  PCSNote
//
//  Created by Yongmo Liang on 7/24/12.
//  Copyright (c) 2012 Baidu Inc. All rights reserved.
//

#import "NoteContentViewController.h"

@interface NoteContentViewController () {
    NSString *content;
    NSString *modifiedDate;
    NSString *fileName;
}

@end

extern NSString *accessToken;


@implementation NoteContentViewController

@synthesize titleFiled;
@synthesize titleLable;
@synthesize timeLabel;
@synthesize isEditMode;
@synthesize textView;
@synthesize detailFile;

-(NSURLRequest*)makeRequest:(NSURL*)url:(NSData*)data:(NSString*)filename
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:50];
    
    NSTimeInterval interval = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *timeStamp = [[NSString alloc] initWithFormat:@"%f", interval];
    
    NSMutableString *contentType = [[NSMutableString alloc] initWithString:@"multipart/form-data; boundary="];
    [contentType appendString:timeStamp];
    //NSString *contentType = [[NSString alloc] initWithString:@"multipart/form-data; boundary=%@", @"01234567890"];
    
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"binary" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString *preBody = [[NSMutableString alloc] init ];
    [preBody appendString:@"--"];
    [preBody appendString:timeStamp];
    [preBody appendString:@"\r\n"];
    
    NSString *tmp = [[NSString alloc] initWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"uploadedfile", filename];
    
    [preBody appendString:tmp];
    [preBody appendString:@"Content-Type: application/octet-stream\r\n\r\n"];
    
    
    NSMutableString *postData = [[NSMutableString alloc] init];
    [postData appendString:@"\r\n--"];
    [postData appendString:timeStamp];
    [postData appendString:@"--"];
    
    NSMutableData *reqData = [[NSMutableData alloc] init];
    
    [reqData appendData:[preBody dataUsingEncoding:NSUTF8StringEncoding]];
    [reqData appendData:data];
    [reqData appendData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:reqData];
    
    return request;
}


- (void) saveFileWithTitle:(NSString *)fileTitle Content:(NSString *) fileContent
{
    NSString *finalFileName = [[[fileTitle stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingFormat:@"%@", @".txt"];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES) objectAtIndex:0] stringByAppendingPathComponent:finalFileName];
    //NSLog(@"path: %@",filePath);
    [[fileContent dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
    
    NSString *baseUrl = @"https://pcs.baidu.com/rest/2.0/pcs/file?";
    baseUrl = [[baseUrl stringByAppendingFormat:@"access_token=%@&method=%@&path=/apps/云端记事本/%@",
               accessToken, @"upload", finalFileName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:baseUrl];
    
    NSURLRequest *request = [self makeRequest:url :[fileContent dataUsingEncoding:NSUTF8StringEncoding] :finalFileName];


    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //NSLog(@"Response Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    //NSLog(@"HTTP Response Status: %d", [response statusCode]);
    //NSLog(@"Response Header: %@", [response allHeaderFields]);

    
    
    if ([data length] > 0 && error == nil)
    {
        
    } else if ([data length] ==0 && error == nil) {
        NSLog(@"No Data");
    } else if  (error) {
        NSLog(@"Error Code: %d", error.code);
    }
}

- (IBAction) navigationItemAction:(id)sender
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Save"]) {
        // Save a note
        
        [self saveFileWithTitle:titleFiled.text Content:self.textView.text];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        // Edit a note
        self.titleLable.hidden = YES;
        self.titleFiled.hidden = NO;
        self.navigationItem.rightBarButtonItem.title = @"Save";
        [self.textView setEditable:YES];
        [self.textView becomeFirstResponder];
    }
}

- (NSString *)getCurrentDateTime
{
    NSDate *tmpDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    NSString *dateString = [dataFormatter stringFromDate:tmpDate];
    return dateString;
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
    
    if (isEditMode == YES) {
        self.navigationItem.rightBarButtonItem.title = @"Save";
        self.titleFiled.hidden = NO;
        self.titleLable.hidden = YES;
        titleFiled.text = @"";
        textView.text = @"";
        [self.titleFiled becomeFirstResponder];
        [self.navigationItem setTitle:@"New Note"];
        [self.timeLabel setText:[self getCurrentDateTime]];
    } else {
        [self.textView setEditable:NO];
        
        NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
        [fomatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *fileMDate = [NSDate dateWithTimeIntervalSince1970:[[detailFile objectForKey:@"mtime"] intValue]];
        modifiedDate = [fomatter stringFromDate:fileMDate];
        
        fileName = [[detailFile objectForKey:@"path"] lastPathComponent];
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];

        content = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        NSLog(@"File Name --------- %@", [fileName stringByDeletingPathExtension]);
        [self.titleFiled setText:[fileName stringByDeletingPathExtension]];
        self.titleFiled.hidden = YES;
        self.titleLable.hidden = NO;
        [self.titleLable setText:[fileName stringByDeletingPathExtension]];
        [self.timeLabel setText:modifiedDate];
        [self.textView setText:content];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
