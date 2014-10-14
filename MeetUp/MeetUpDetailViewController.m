//
//  MeetUpDetailViewController.m
//  MeetUp
//
//  Created by Taylor Wright-Sanson on 10/13/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "MeetUpDetailViewController.h"
#import "WebViewController.h"
#import "CommentsTableViewCell.h"
#import "ProfileViewController.h"

@interface MeetUpDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *rsvpCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostInfoLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property NSMutableArray *comments;
@property NSMutableArray *members;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation MeetUpDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.members = [[NSMutableArray alloc] init];

    self.navigationItem.title = self.meetUp.name;
    self.hostInfoLabel.text = [@"Host: " stringByAppendingString:self.meetUp.hostName];
    self.rsvpCountLabel.text = [@"RSVP Count: " stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.meetUp.rsvpCount]];
    [self.webView loadHTMLString:self.meetUp.meetUpDescription baseURL:nil];

    NSString *key = @"11744725b2c306e2d9711156454a12";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&group_id=%@&page=20&key=%@", self.meetUp.groupID, key]]];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (data)
        {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.comments = results[@"results"];
            [self.tableView reloadData];

            for (NSDictionary *memberDict in self.comments)
            {
                [self.members addObject:[memberDict[@"member_id"] stringValue]];
            }
        }
        else
        {
            NSLog(@"Meetup detail data fail");
        }
    }];
}

#pragma mark - Table View Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDictionary *comment = [self.comments objectAtIndex:indexPath.row];

    cell.commentLabel.text = comment[@"comment"];
    cell.memberNameLabel.text = comment[@"member_name"];

    NSDate *time = [NSDate dateWithTimeIntervalSince1970:[comment[@"time"] intValue]];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", time];

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if ([segue.identifier isEqualToString:@"WebViewSegue"])
    {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.meetUp = self.meetUp;
    }
    else if ([segue.identifier isEqualToString:@"MemberSegue"])
    {
        ProfileViewController *profileViewController = segue.destinationViewController;
        profileViewController.memberID = [self.members objectAtIndex:indexPath.row];
    }
}

@end
