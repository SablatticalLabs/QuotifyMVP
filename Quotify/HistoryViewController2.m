//
//  HistoryViewController2.m
//  Quotify
//
//  Created by Lior Sabag on 17/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController2.h"
#import "QuoteWebViewController.h"

@implementation HistoryViewController2
@synthesize quoteHistTableView;
@synthesize loadingIndicator;
@synthesize loadingView;
@synthesize quotifierID;
@synthesize sectionedQuotesArray = _sectionedQutoesArray;


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
    
    // Set data source and control of the Table View
    self.quoteHistTableView.dataSource = self;
    self.quoteHistTableView.delegate = self;
    
    // init array of quotes
    quotesArray = [[NSArray alloc] init];
    self.sectionedQuotesArray = [[NSMutableArray alloc] init];
    
    // Creat an instance to access the data in the comm class
    myComm = [[Comm alloc] init];
    [myComm requestQuoteListforQuotifier:self.quotifierID AndSendResultTo:self];

}

// Here is where we sort the list
// This gets called once Comm is done downloading the quoteList
-(void)quoteListResult:(NSDictionary*)listDict{
    NSLog(@"hist dict: %@", listDict);
    quotesArray = [listDict objectForKey:@"quote_history"];
    
    lockedQuotes = [[NSMutableArray alloc] init];
    viewableQuotes = [[NSMutableArray alloc] init];
    
    // Future functionality - Editable quotes
    //NSMutableArray * editableQuotes = [[NSMutableArray alloc] init];
    
    
    // Check the messages_sent_flag to see if quote is locked and place in appropriate array
    for (NSDictionary* quoteDict in quotesArray) {
    
        //NSLog(@"Message flag: %@", [quoteDict objectForKey:@"messages_sent_flag"]);
        
        if([[quoteDict objectForKey:@"messages_sent_flag"] boolValue]){
            [viewableQuotes addObject:quoteDict];
        }
        
        else{
            [lockedQuotes addObject:quoteDict];
        }
    }

    
    [self.sectionedQuotesArray addObject:viewableQuotes];
    [self.sectionedQuotesArray addObject:lockedQuotes];
    
    [self.quoteHistTableView reloadData];
    [self.loadingIndicator stopAnimating];
    
    self.loadingView.hidden = YES;
}

///////////////////////
///////////////////////
// **THIS IS THE SECTION THAT NEEDS TO BE WORKED ON**
///////////////////////
///////////////////////

#pragma mark - Table view data source

// Set how many sections the Table View will have
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int numberOfSections = self.sectionedQuotesArray.count;
    // Return the number of sections.
    return numberOfSections;
}

// Set the number of rows in each section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowsInSection = [[self.sectionedQuotesArray objectAtIndex:section] count];
    return rowsInSection;
}

// Display section headings
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Viewable Quotes";
    else
        return @"Locked Quotes";
}

// This is where we configure each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // Memory management - reuse cells when possible to avoid holding large arrays in memory
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell..
    NSDictionary * quoteDict = [[self.sectionedQuotesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //    if(indexPath.section == 0){
    //        quoteDict = [viewableQuotes objectAtIndex:indexPath.row];
    //    }
    //    else{
    //        quoteDict = [lockedQuotes objectAtIndex:indexPath.row];
    //    }
    
    // Grab the speaker's name from the quote object
    NSDictionary* speakerInfo;
    speakerInfo = [quoteDict valueForKey:@"speaker"];
    NSString* speakerName = [speakerInfo objectForKey:@"name"];

    
    
    // Grab the raw date info from the quote object
    NSString* quoteString;
    quoteString = [quoteDict objectForKey:@"quote_text"];
    
    //////////
    // Date formatting
    //////////
    
    // Grab the raw date info from the quote object
    NSString* dateString;
    dateString = [quoteDict objectForKey:@"created_at"];
    
    // Format the raw date info
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Remove the letter "Z" from the date?
    dateString = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];    
    NSDate* date = [df dateFromString:dateString];
    
    // Set a new date format and convert from GMT to local time
    [df setDateFormat:@"EEE, MMM d, yyyy"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    //////////
    // Cell formatting
    //////////
    
    
    // Set the cell to highlight blue when pressed    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    
    // Set display for locked quotes
    if(!indexPath.section == 0){
        
        // Disable selection of locked quotes
        cell.userInteractionEnabled = FALSE;
        
        // Write the date in top half of cell
        cell.textLabel.text = [df stringFromDate:date];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
        // Print time in lower half of cell
        [df setDateFormat:@"h:mm a"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[df stringFromDate:date], [df stringFromDate:date]];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Set display for unlocked quotes
    else
        // Put the quote text in top half of cell
        cell.textLabel.text = speakerName;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        // Put the date in lower half of cell
        cell.detailTextLabel.text = quoteString;
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        return cell;
}


#pragma mark - Table view delegate

// Action when a row is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Display the selected quote in a Web View
    NSString* quoteID = [[quotesArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    QuoteWebViewController *wvc = [[QuoteWebViewController alloc] init];
    wvc.quoteURL = [NSString stringWithFormat:@"http://www.quotify.it/%@/",quoteID];
    
    [self presentModalViewController:wvc animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Put the accessory button action in here
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
// }

- (void)viewDidUnload
{
    [self setQuoteHistTableView:nil];
    [self setLoadingIndicator:nil];
    [self setLoadingView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backToQuoteEntry:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}



@end
