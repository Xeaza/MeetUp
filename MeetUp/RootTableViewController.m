//
//  RootTableViewController.m
//  MeetUp
//
//  Created by Taylor Wright-Sanson on 10/13/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "RootTableViewController.h"
#import "MeetUpDetailViewController.h"
#import "MeetUp.h"

@interface RootTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *meetUpsArray;
@property NSMutableArray *searchResults;
//@property NSMutableArray *searchNames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation RootTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.meetUpsArray = [[NSMutableArray alloc] init];

    // Create a mutable array to contain products for the search results table.
    self.searchResults = [[NSMutableArray alloc] init];

    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];

    self.searchController.searchResultsUpdater = self;

    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);

    self.tableView.tableHeaderView = self.searchController.searchBar;

    self.definesPresentationContext = YES;

    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=11744725b2c306e2d9711156454a12"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSError *jsonError;
         // Get json as string and print it
         //NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         //NSLog(@"%@", jsonString);

         if (connectionError != nil)
         {
             NSLog(@"Connection error: %@", connectionError.localizedDescription);
         }
         if (jsonError != nil)
         {
             NSLog(@"JSON error: %@", jsonError.localizedDescription);
         }

         NSDictionary *meetUpsJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

         NSArray *arrayOfMeetUpDictionaries =  [meetUpsJson objectForKey:@"results"];

         // Loop through the local arrayOfMeetUpDictionaries and add make a meetup object out of each one and add it to self.meetUpsArray
         // The MeetUp class takes care of parsing all the data
         for (NSDictionary *meetUpDictionary in arrayOfMeetUpDictionaries)
         {
             MeetUp *meetUp = [[MeetUp alloc] initWithDictionary:meetUpDictionary];
             [self.meetUpsArray addObject:meetUp];

             // For Search
             [self.searchResults addObject:meetUp.name];
         }

         [self.tableView reloadData];
     }];

}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*  If the requesting table view is the search controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
     */
    if (tableView == ((UITableViewController *)self.searchController).tableView)
    {
        return self.searchResults.count;

    } else
    {
        return self.meetUpsArray.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    MeetUp *meetUp; //[self.meetUpsArray objectAtIndex:indexPath.row];

    if (tableView == ((UITableViewController *)self.searchController.searchResultsController).tableView)
    {
        meetUp = [self.searchResults objectAtIndex:indexPath.row];
    } else
    {
        meetUp = [self.meetUpsArray objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = meetUp.name;
    cell.detailTextLabel.text = meetUp.address;

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if ([segue.identifier isEqualToString:@"MeetUpDetail"])
    {
        MeetUpDetailViewController *meetUpDetailViewController = segue.destinationViewController;
        meetUpDetailViewController.meetUp = [self.meetUpsArray objectAtIndex:indexPath.row];
    }
}

#pragma mark - Search

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{

    NSString *searchString = [self.searchController.searchBar text];
    NSString *scope = nil;

    for (MeetUp *meetUp in self.meetUpsArray)
    {
        if ((scope == nil) || [meetUp.name isEqualToString:scope])
        {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange meetUpNameRange = NSMakeRange(0, meetUp.name.length);
            NSRange foundRange = [meetUp.name rangeOfString:searchString options:searchOptions range:meetUpNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:meetUp];
            }
        }
        
    }
    
    [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
}

@end
