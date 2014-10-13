//
//  ViewController.m
//  MeetUp
//
//  Created by Taylor Wright-Sanson on 10/13/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "RootViewController.h"
#import "MeetUpDetailViewController.h"
#import "MeetUp.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *meetUpsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.meetUpsArray = [[NSMutableArray alloc] init];

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
         }

         [self.tableView reloadData];
     }];

}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.meetUpsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    MeetUp *meetUp = [self.meetUpsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = meetUp.name;
    cell.detailTextLabel.text = meetUp.address;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if ([segue.identifier isEqualToString:@"MeetUpDetail"])
    {
        MeetUpDetailViewController *meetUpDetailViewController = segue.destinationViewController;
        meetUpDetailViewController.meetUp = [self.meetUpsArray objectAtIndex:indexPath.row];
    }
}

@end
