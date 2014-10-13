//
//  MeetUpDetailViewController.m
//  MeetUp
//
//  Created by Taylor Wright-Sanson on 10/13/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "MeetUpDetailViewController.h"
#import "WebViewController.h"

@interface MeetUpDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostInfoLabel;
@property (weak, nonatomic) IBOutlet UITextView *meetUpDescriptionTextField;

@end

@implementation MeetUpDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.meetUp.name;
    self.hostInfoLabel.text = [@"Host: " stringByAppendingString:self.meetUp.hostName];
    self.rsvpCountLabel.text = [@"RSVP Count: " stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.meetUp.rsvpCount]];
    self.meetUpDescriptionTextField.text = self.meetUp.meetUpDescription;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"WebViewSegue"])
    {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.meetUp = self.meetUp;
    }
}

@end
