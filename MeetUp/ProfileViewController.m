//
//  ProfileViewController.m
//  MeetUp
//
//  Created by Taylor Wright-Sanson on 10/13/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioTextField;
@property (weak, nonatomic) IBOutlet UILabel *interestsLabel;

@property NSMutableDictionary *member;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.member = [[NSMutableDictionary alloc] init];

    // Get the member information with the memberID that was passed from the comment selected in MeetUpDetailViewController
    NSString *key = @"11744725b2c306e2d9711156454a12";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=%@", self.memberID, key]]];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

         // Fill all the user's profile information.
         // City, state, photo, bio, interests
         self.navigationItem.title = results[@"name"];
         NSURL *imageUrl = [NSURL URLWithString:results[@"photo"][@"highres_link"]];
         self.profilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
         NSString *userState = results[@"state"];
         NSString *userCity = results[@"city"];
         self.locationLabel.text = [[userCity stringByAppendingString:@", "] stringByAppendingString:userState];
         self.bioTextField.text = results[@"bio"];

         NSArray *interestArray = results[@"topics"];
         [interestArray componentsJoinedByString: @", "];
         NSMutableArray *interests = [NSMutableArray array];
         for (NSDictionary *interestDict in interestArray)
         {
             [interests  addObject:interestDict[@"name"]];
         }

         self.interestsLabel.text = [interests componentsJoinedByString: @", "];

     }];

}


@end
