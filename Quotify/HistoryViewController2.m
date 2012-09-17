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
@synthesize sectionedQuotesArray = _sectionedQuotesArray;
@synthesize deletableQuotes = _deletableQuotes;
@synthesize viewableQuotes = _viewableQuotes;
@synthesize lockedQuotes = _lockedQuotes;


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
    
    self.deletableQuotes = [[NSMutableArray alloc] init];
    self.lockedQuotes = [[NSMutableArray alloc] init];
    self.viewableQuotes = [[NSMutableArray alloc] init];
    
    
    // Check the messages_sent_flag to see if quote is locked and place in appropriate array
    for (NSDictionary* quoteDict in quotesArray) {
        
        if([[quoteDict objectForKey:@"is_deletable?"] boolValue]){
            [self.deletableQuotes addObject:quoteDict];
        }
        
        else if([[quoteDict objectForKey:@"messages_sent_flag"] boolValue]){
            [self.viewableQuotes addObject:quoteDict];
        }
        
        else{
            [self.lockedQuotes addObject:quoteDict];
        }
    }

    //Order arrays appear in sectionedQuotesArray is the order in which they'll be displayed!!!
    [self.sectionedQuotesArray addObject:self.deletableQuotes];
    [self.sectionedQuotesArray addObject:self.viewableQuotes];
    [self.sectionedQuotesArray addObject:self.lockedQuotes];
    
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
    //int numberOfSections = self.sectionedQuotesArray.count;
    // Return the number of sections.
    return 1;//numberOfSections;
}

// Set the number of rows in each section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //int rowsInSection = [[self.sectionedQuotesArray objectAtIndex:section] count];
    return [quotesArray count];//rowsInSection;
}

//// Display section headings
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if(section == 0)
//        return @"Viewable Quotes";
//    else
//        return @"Locked Quotes";
//}



// This is where we configure each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSDictionary * quoteDict;
    static NSString* ident;
    
    int length0 = [[self.sectionedQuotesArray objectAtIndex:0] count];
    int length1 = [[self.sectionedQuotesArray objectAtIndex:1] count];
    int section;
    
    if(indexPath.row < length0){
        quoteDict = [[self.sectionedQuotesArray objectAtIndex:0] objectAtIndex:indexPath.row];
        section = 0;
        ident = @"deletable";
    }
    else if(indexPath.row < length0 + length1){
        quoteDict = [[self.sectionedQuotesArray objectAtIndex:1] objectAtIndex:indexPath.row - length0];
        section = 1;
        ident = @"viewable";
    }
    else{
        quoteDict = [[self.sectionedQuotesArray objectAtIndex:2] objectAtIndex:indexPath.row - (length0 + length1)];
        section = 2;
        ident = @"locked";
    }
    
    // Need 3 types of cell identifiers
    //static NSString *CellIdentifier = @"Cell";
    
    // Memory management - reuse cells when possible to avoid holding large arrays in memory
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:ident];
    }
    
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
    
    //3 way IF to configure different types of cells.
    if([ident isEqualToString:@"deletable"]){
        
        cell.textLabel.text = @"deletable";
        [cell setEditing:YES];
    }
    else if([ident isEqualToString:@"viewable"]){
        // Set display for unlocked quotes
        [df setDateFormat:@"M/d/yy"];
            
        // Put the quote text in top half of cell
        cell.textLabel.text = quoteString;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        // Put the date in lower half of cell
        cell.detailTextLabel.text = [speakerName stringByAppendingFormat:@" on %@", [df stringFromDate:date]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else{//@"locked"
        
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

    
    // Set the cell to highlight blue when pressed    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    
    return cell;
}


#pragma mark - Table view delegate

// Action when a row is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"viewable"]){
        // Display the selected quote in a Web View
        NSString* personalQuoteID = [[self.viewableQuotes objectAtIndex:(indexPath.row - [self.deletableQuotes count])] objectForKey:@"personalized_quote_id"];
        QuoteWebViewController *wvc = [[QuoteWebViewController alloc] init];
        wvc.quoteURL = [NSString stringWithFormat:@"http://www.quotify.it/%@/",personalQuoteID];
    
        [self presentModalViewController:wvc animated:YES];
    }

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if([[tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"deletable"]){
        return YES;
    }
    else return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray * array;//not used right now
        int quoteIndex = [self getQuoteIndexInArray:array forIndexPath:indexPath];
         //call comm method to delete quote from server.
        [myComm deleteQuoteWithID:[[self.deletableQuotes objectAtIndex:quoteIndex] objectForKey:@"id"]];
        [self.deletableQuotes removeObjectAtIndex:quoteIndex];//for now, definitely in deletable quotes
        //NSLog(@"%@",[array count]);
        //call comm me     [tableView reloadData];
    }    
}

// Put the accessory button action in here
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
// }

//helper method. IMPORTANT: array is "output". the method will set that pointer to the correct array (deletable, viewable, or locked)
//doesn't work right now (*array points to null)
- (int)getQuoteIndexInArray:(NSMutableArray *)array forIndexPath:(NSIndexPath *)indexPath {
    
    int quoteIndex;
    //static NSString* ident;
    
    int length0 = [[self.sectionedQuotesArray objectAtIndex:0] count];
    int length1 = [[self.sectionedQuotesArray objectAtIndex:1] count];
    
    if(indexPath.row < length0){
        array = [self.sectionedQuotesArray objectAtIndex:0];
        quoteIndex = indexPath.row;
        //ident = @"deletable";
    }
    else if(indexPath.row < length0 + length1){
        array = [self.sectionedQuotesArray objectAtIndex:1];
        quoteIndex = indexPath.row - length0;
        //ident = @"viewable";
    }
    else{
        array = [self.sectionedQuotesArray objectAtIndex:2];
        quoteIndex = indexPath.row - (length0 + length1);
        //ident = @"locked";
    }
    return quoteIndex;
}



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
