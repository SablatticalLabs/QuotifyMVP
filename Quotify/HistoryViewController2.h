//
//  HistoryViewController2.h
//  Quotify
//
//  Created by Lior Sabag on 17/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comm.h"

@interface HistoryViewController2 : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    Comm * myComm;
    NSDictionary *data;
    NSArray *quotesArray;
    
    __strong NSMutableArray * lockedQuotes;
    __strong NSMutableArray * editableQuotes;
    __strong NSMutableArray * viewableQuotes;

}

//@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITableView *quoteHistTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) NSString* quotifierID;
@property (strong, nonatomic) NSMutableArray * sectionedQuotesArray;

- (IBAction)backToQuoteEntry:(id)sender;
-(void)quoteListResult:(NSDictionary*)listDict;


@end
