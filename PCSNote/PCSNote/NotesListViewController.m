//
//  NotesListViewController.m
//  PCSNote
//
//  Created by Yongmo Liang on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesListViewController.h"
#import "SBJson.h"


extern NSString *accessToken;

@interface NotesListViewController () {
    NSArray *fileList;
}

@end

@implementation NotesListViewController

@synthesize fileListJson;

- (IBAction)refreshNotesList:(id)sender
{
    
}

- (IBAction)newNote:(id)sender
{

}

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    return self;
}
 */
- (id) init
{
    self = [super init];
    return self;
}


- (void) getFileInfoList
{
    
    NSLog(@"Access Token: %@", accessToken);
    
    NSString *baseUrl = @"https://pcs.baidu.com/rest/2.0/pcs/file?";
    baseUrl = [baseUrl stringByAppendingFormat:@"access_token=%@&method=%@&path=/apps/云端记事本", accessToken, @"list"];
    baseUrl = [baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:baseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if ([data length] > 0 && error == nil)
    {
        NSLog(@"Has Data");
        fileListJson = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
    } else if ([data length] ==0 && error == nil) {
        NSLog(@"No Data");
    } else if  (error) {
        NSLog(@"ends with error");
        NSLog(@"%@", error);
    }
    
    //NSLog(@"%@", fileListJson);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *fileListDict = [parser objectWithString:fileListJson error:nil];
    fileList = [fileListDict objectForKey:@"list"];
    
    /*
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if ([data length] > 0 && error == nil)
        {
            NSLog(@"Has Data");
            fileListJson = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            
        } else if ([data length] ==0 && error == nil) {
            NSLog(@"No Data");
        } else if  (error) {
            NSLog(@"ends with error");
            NSLog(@"%@", error);
        }
        
        NSLog(@"%@", fileListJson);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *fileListDict = [parser objectWithString:fileListJson error:nil];
        fileList = [fileListDict objectForKey:@"list"];
    }];
     */
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self getFileInfoList];
    
    
    if ([fileList count]>0) {
        for (NSDictionary *file in fileList) {
            NSString *path = [file objectForKey:@"path"];
            NSString *mtime = [file objectForKey:@"mtime"];
            NSLog(@"%@ - %@", path, mtime);
        }
    } else {
        NSLog(@" No File List");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Get array based on fileListJson
    
    
    

    //NSDictionary *fileArray = [parser objectWithString:fileInfoJson error:nil];
    //NSLog(@"%@", fileArray);
    /*
    for (NSDictionary *file in fileArray)  {
        NSLog(@"Hello World");
    }
    */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 0;
    return [fileList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    NSLog(@"Configure the Cell");
    
    /*
    NSDictionary *file = [fileList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [file objectForKey:@"path"];
    cell.detailTextLabel.text = [file objectForKey:@"mtime"];
    */
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
