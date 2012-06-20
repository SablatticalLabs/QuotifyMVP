//
//  HistoryViewController2.m
//  Quotify
//
//  Created by Lior Sabag on 17/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController2.h"

@implementation HistoryViewController2
@synthesize quoteHistTableView;
@synthesize loadingIndicator;
@synthesize loadingView;
@synthesize quotifierID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.quoteHistTableView.dataSource = self;
    self.quoteHistTableView.delegate = self;
    
    //init quotesArray
    quotesArray = [[NSArray alloc] init];
    
    
    myComm = [[Comm alloc] init];
    [myComm requestQuoteListforQuotifier:self.quotifierID AndSendResultTo:self];

}

-(void)quoteListResult:(NSDictionary*)listDict{
    NSLog(@"hist dict: %@", listDict);
    quotesArray = [listDict objectForKey:@"quote_history"];
    
    [self.quoteHistTableView reloadData];
    [self.loadingIndicator stopAnimating];
    self.loadingView.hidden = YES;
}


- (void)viewDidUnload
{
    [self setQuoteHistTableView:nil];
    [self setLoadingIndicator:nil];
    [self setLoadingView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backToQuoteEntry:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [quotesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell..
    
    NSString * str = [[quotesArray objectAtIndex:indexPath.row] objectForKey:@"created_at"];
    
//    NSDateFormatter* df_utc = [[NSDateFormatter alloc] init];
//    [df_utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    [df_utc setDateFormat:@"yyyy.MM.dd G 'at' HH:mm:ss zzz"];
//    
//    NSDateFormatter* df_local = [[NSDateFormatter alloc] init] ;
//    [df_local setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
//    [df_local setDateFormat:@"yyyy.MM.dd G 'at' HH:mm:ss zzz"];
//    
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    str = [str stringByReplacingOccurrencesOfString:@"Z" withString:@""];    
    NSDate* date = [df dateFromString:str];
    
    
    [df setDateFormat:@"EEE, MMM d, yyyy"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    cell.textLabel.text = [df stringFromDate:date];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    [df setDateFormat:@"h:mm a"];
    cell.detailTextLabel.text = [df stringFromDate:date];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    
    
    UIImage* _image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"kinder_egg" ofType: @"jpg"]];
    
    //Trying to fix the annoying corner but it's not working...
    [cell setAutoresizesSubviews:YES];
    cell.imageView.frame = CGRectMake(3, 3, 65, 65);
    
    // Put the image in the cell
    [cell.imageView setImage:_image];

    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
//    imageView.frame = CGRectMake(6.5, 6.5, 65, 65);
//    [cell setImage:imageView.image];
    
    return cell;
}

//UIImageView *imageView = [[UIImageView alloc] initWithImage:photo];
//imageView.frame = CGRectMake(6.5, 6.5, 65., 65.);
//[cell addSubview:imageView];

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
