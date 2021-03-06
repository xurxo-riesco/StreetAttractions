//
//  DetailsViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/13/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "DetailsViewController.h"

// View Controllers
#import "ProfileViewController.h"
#import "User.h"

@interface DetailsViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation DetailsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  // PinchGesture Set Up
  if (self.post.hasVideo) {
    self.videoLabel.alpha = 0.75;
    self.pinch = NO;
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(didPinchIn:)];
    [self.view addGestureRecognizer:pinchGesture];
    [self.view setUserInteractionEnabled:YES];
  } else {
    self.videoLabel.alpha = 0;
  }
  // Liking Set Up
  [User hasLiked:self.post
  WithCompletion:^(BOOL completion) {
    if (completion) {
      self.barButton.image = [UIImage systemImageNamed:@"heart.fill"];
    } else {
      self.barButton.image = [UIImage systemImageNamed:@"heart"];
    }
  }];
  self.barButton.image = [UIImage systemImageNamed:@"heart"];

  // Rating Set Up
  self.starView.allowsHalfStars = YES;
  [User hasRated:self.post
  WithCompletion:^(BOOL completion) {
    if (completion) {
      [self setRating];
    }
  }];

  // Visual Set Up
  User *author = (User *)self.post.author;
  self.commentsButton.layer.cornerRadius = 8;
  self.commentsButton.layer.masksToBounds = YES;
  self.profilePic.layer.cornerRadius = 17.5;
  self.profilePic.layer.masksToBounds = YES;
  self.mediaView.layer.cornerRadius = 10;
  self.mediaView.layer.masksToBounds = YES;
  self.mediaView.file = self.post.media;
  [self.mediaView loadInBackground];
  self.profilePic.file = author.profilePic;
  [self.profilePic loadInBackground];
  self.userLabel.text = author.screenname;
  self.dateLabel.text = self.post.created_At.timeAgoSinceNow;
  self.descriptionLabel.text = self.post.caption;
  self.categoryLabel.text = self.post.category;
  self.categoryLabel.textColor = [self.post.category colorCode];

  // CalendarEvent Set Up
  if (self.post.isUpcoming) {
    self.calendarButton.alpha = 1;
    self.calendarButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.calendarButton.titleLabel.numberOfLines = 2;
    [self.calendarButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
  } else {
    self.calendarButton.alpha = 0;
    self.calendarButton.enabled = NO;
  }

  // GestureRecognizer Set Up
  UITapGestureRecognizer *postTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(didTapAuthor:)];
  postTap.numberOfTapsRequired = 1;
  [self.userLabel addGestureRecognizer:postTap];
  [self.userLabel setUserInteractionEnabled:YES];

  // Map Set Up
  self.mapView.delegate = self;
  MKCoordinateRegion postRegion = MKCoordinateRegionMake(
  CLLocationCoordinate2DMake(self.post.latitude.floatValue, self.post.longitude.floatValue),
  MKCoordinateSpanMake(0.1, 0.1));
  [self.mapView setRegion:postRegion animated:false];
  [self loadMap];

  // Claim Set Up
  if ([User currentUser].isPerfomer) {
    User *author = (User *)self.post.author;
    if ([author.username isEqual:[User currentUser].username] || author.isPerfomer || self.post.originalAuthor != nil) {
      self.claimButton.tintColor = [UIColor clearColor];
      self.claimButton.enabled = NO;
    } else {
      self.claimButton.tintColor = [UIColor blackColor];
      self.claimButton.enabled = YES;
      [User hasClaimed:self.post
        WithCompletion:^(BOOL completion) {
          if (completion) {
            self.claimButton.image = [UIImage systemImageNamed:@"bookmark.fill"];
          } else {
            self.claimButton.image = [UIImage systemImageNamed:@"bookmark"];
          }
        }];
    }
    self.claimButton.image = [UIImage systemImageNamed:@"bookmark"];
  } else {
    self.claimButton.tintColor = [UIColor clearColor];
    self.claimButton.enabled = NO;
  }

  if (self.post.originalAuthor != nil) {
    User *user = (User *)self.post.originalAuthor;
    self.originalAuthor.text = [NSString stringWithFormat:@"Posted by %@", user.screenname];
    self.dateLabel.text = self.post.created_At.shortTimeAgoSinceNow;
    UITapGestureRecognizer *originalTap = [[UITapGestureRecognizer alloc]
    initWithTarget:self
            action:@selector(didTapOriginalAuthor:)];
    originalTap.numberOfTapsRequired = 1;
    [self.originalAuthor addGestureRecognizer:originalTap];
    [self.originalAuthor setUserInteractionEnabled:YES];
  } else {
    self.originalAuthor.text = @"";
  }
}

#pragma mark - TapGestureRecognizer
- (void)didTapOriginalAuthor:(UITapGestureRecognizer *)sender
{
  self.user = (User *)self.post.originalAuthor;
  [self performSegueWithIdentifier:@"detailsToProfile" sender:nil];
}

#pragma mark - PinchGestureRecognizer
- (void)didPinchIn:(UIPinchGestureRecognizer *)sender
{
  if (sender.scale <= 1.0 && self.pinch == NO) {
    self.pinch = YES;
    PFFileObject *data = self.post.video;
    [data getDataInBackgroundWithBlock:^(NSData *_Nullable data, NSError *_Nullable error) {
      if (data) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"myMove.mp4"];

        [data writeToFile:path atomically:YES];
        NSURL *moveUrl = [NSURL fileURLWithPath:path];
        self.avPlayer = [AVPlayer playerWithURL:moveUrl];
        self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        self.videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
        self.videoLayer.frame = self.view.bounds;
        self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:self.videoLayer];
        [self.avPlayer play];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(itemDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.avPlayer currentItem]];

      } else {
        NSLog(@"Error");
      }
    }];
  } else if (sender.scale > 1.0 && self.pinch == YES) {
    [self.videoLayer removeFromSuperlayer];
    [self.avPlayer pause];
    self.pinch = NO;
  }
}

- (void)itemDidFinishPlaying:(NSNotification *)notification
{
  AVPlayerItem *player = [notification object];
  [player seekToTime:kCMTimeZero];
}

- (void)loadMap
{
  NSNumber *latitude = self.post.latitude;
  NSNumber *longitude = self.post.longitude;
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
  MKPointAnnotation *annotation = [MKPointAnnotation new];
  annotation.coordinate = coordinate;
  annotation.title = self.post.category;
  [self.mapView addAnnotation:annotation];
}

#pragma mark - Annotations
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView
  dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
  if (annotationView == nil) {
    annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
    annotationView.canShowCallout = true;
    annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
  }
  UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  [detailButton setImage:[UIImage systemImageNamed:@"info.circle"] forState:UIControlStateNormal];
  annotationView.rightCalloutAccessoryView = detailButton;
  return annotationView;
}

// Annotation Delegate
- (void)mapView:(MKMapView *)mapView
               annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
  NSString *routeString = [NSString stringWithFormat:@"https://www.google.com/maps/search/?api=1&query=%f,%f",
                                                     self.post.latitude.floatValue,
                                                     self.post.longitude.floatValue];
  NSURL *routeURL = [NSURL URLWithString:routeString];
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Directions"
                                                                       message:@"Choose an app to get directions"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
  UIAlertAction *googleMaps = [UIAlertAction actionWithTitle:@"Google Maps"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                       if ([[UIApplication sharedApplication] canOpenURL:routeURL]) {
                                                         [[UIApplication sharedApplication] openURL:routeURL];
                                                       }
                                                     }];
  [actionSheet addAction:googleMaps];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - Rate
- (IBAction)onRate:(id)sender
{
  self.post.timesRated = [NSNumber numberWithInt:([self.post.timesRated intValue] + 1)];
  if (self.post.rating != nil) {
    NSNumber *newRating = [NSNumber
    numberWithFloat:(self.starView.value + (self.post.rating.floatValue * (self.post.timesRated.intValue - 1))) /
                    self.post.timesRated.intValue];
    self.post.rating = newRating;
  } else {
    self.post.rating = [NSNumber numberWithFloat:self.starView.value];
  }

  // Rate in background
  [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
    if (succeeded) {
      [self setRating];
    }
  }];
}

// Set the rating view
- (void)setRating
{
  self.rateButton.enabled = NO;
  self.starView.userInteractionEnabled = NO;
  self.starView.value = 0;
  PFRelation *relation = [[User currentUser] relationForKey:@"RatedPosts"];
  [relation addObject:self.post];
  [[User currentUser] saveInBackground];
  [UIView animateWithDuration:5
                   animations:^{
                     self.starView.value = self.post.rating.floatValue;
                     self.starView.tintColor = [UIColor colorWithRed:234.0 / 255.0
                                                               green:230.0 / 255.0
                                                                blue:229.0 / 255.0
                                                               alpha:1];
                   }];
}

#pragma mark - Share
- (IBAction)onShare:(id)sender
{
  NSString *shareText = [NSString
  stringWithFormat:@"Download StreetAttractions and check out this awesome street %@ in %@",
                   self.post.category,
                   self.post.city];
  UIImage *image = self.mediaView.image;
  NSArray *sharedObjects = [NSArray arrayWithObjects:image, shareText, nil];
  UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
  initWithActivityItems:sharedObjects
  applicationActivities:nil];
  activityViewController.popoverPresentationController.sourceView = self.view;
  [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Liking
- (IBAction)onLike:(id)sender
{
  if ([self.barButton.image isEqual:[UIImage systemImageNamed:@"heart"]]) {
    [self like];
  } else {
    [self unlike];
  }
}

- (void)like
{
  // Sets the post as liked by the user in the server
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"LikedPost"];
  [relation addObject:self.post];
  [user saveInBackground];
  self.post.likeCount = [NSNumber numberWithInt:([self.post[@"likeCount"] intValue] + 1)];
  [self.post saveInBackground];

  // Changes the liking button state to reflect the backend change
  self.barButton.image = [UIImage systemImageNamed:@"heart.fill"];
}

- (void)unlike
{
  // Sets the post as liked by the user in the server
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"LikedPost"];
  [relation removeObject:self.post];
  [user saveInBackground];
  self.post.likeCount = [NSNumber numberWithInt:([self.post[@"likeCount"] intValue] - 1)];
  [self.post saveInBackground];

  // Changes the liking button state to reflect the backend change
  self.barButton.image = [UIImage systemImageNamed:@"heart"];
}
- (IBAction)didClaim:(id)sender
{
  if ([self.claimButton.image isEqual:[UIImage systemImageNamed:@"bookmark"]]) {
    [self claim];
  } else {
    [self unclaim];
  }
}
- (void)claim
{
  // Sets the post as claimed by the performer in the server
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"ClaimedPost"];
  [relation addObject:self.post];
  [user saveInBackground];

  // Changes the claim button state to reflect the backend change
  self.claimButton.image = [UIImage systemImageNamed:@"bookmark.fill"];
}

- (void)unclaim
{
  // Sets the post as unclaimed by the performer in the server
  User *user = [User currentUser];
  PFRelation *relation = [user relationForKey:@"ClaimedPost"];
  [relation removeObject:self.post];
  [user saveInBackground];

  // Changes the claim button state to reflect the backend change
  self.claimButton.image = [UIImage systemImageNamed:@"bookmark"];
}
#pragma mark - Calendar
- (IBAction)onCalendarApp:(id)sender
{
  EKEventStore *store = [EKEventStore new];
  [store requestAccessToEntityType:EKEntityTypeEvent
                        completion:^(BOOL granted, NSError *error) {
                          if (granted) {
                            EKEvent *event = [EKEvent eventWithEventStore:store];
                            event.title = self.post.category;
                            event.startDate = self.post.upcomingDate;
                            event.endDate = self.post.upcomingDate;
                            event.calendar = [store defaultCalendarForNewEvents];
                            NSError *err = nil;
                            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                          }
                        }];
  self.calendarButton.hidden = YES;
  self.calendarButton.enabled = NO;
}

#pragma mark - Navigation
- (void)didTapAuthor:(UITapGestureRecognizer *)sender
{
  self.user = (User *)self.post.author;
  [self performSegueWithIdentifier:@"detailsToProfile" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqual:@"toCommentsVC"]) {
    CommentsViewController *commentsViewController = [segue destinationViewController];
    commentsViewController.post = self.post;
  } else {
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = self.user;
  }
}

@end
