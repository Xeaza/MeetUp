//
//  MeetUpDetailViewController.m
//  MeetUp
//
//  Created by Taylor Wright-Sanson on 10/13/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "MeetUpDetailViewController.h"

@interface MeetUpDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetUpDescriptionLabel;

@end

@implementation MeetUpDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.meetUp.name;
    self.hostInfoLabel.text = [@"Host: " stringByAppendingString:self.meetUp.hostName];
    self.rsvpCountLabel.text = [@"RSVP Count: " stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.meetUp.rsvpCount]];
    self.meetUpDescriptionLabel.text = self.meetUp.meetUpDescription;
}


@end
