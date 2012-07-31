//
//  NoteContentViewController.m
//  PCSNote
//
//  Created by Yongmo Liang on 7/24/12.
//  Copyright (c) 2012 Baidu Inc. All rights reserved.
//

#import "NoteContentViewController.h"

@interface NoteContentViewController () 

@end

@implementation NoteContentViewController

@synthesize timeLabel;
@synthesize isEditMode;
@synthesize textView;
@synthesize detailFile;

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
        textView.text = @"";
        [self.textView becomeFirstResponder];
        [self.navigationItem setTitle:@"New Note"];
        [self.timeLabel setText:[self getCurrentDateTime]];
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        [self.textView setText:[detailFile objectForKey:@""]];
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
