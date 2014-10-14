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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=477d1928246a4e162252547b766d3c6d", self.memberID]]];

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
