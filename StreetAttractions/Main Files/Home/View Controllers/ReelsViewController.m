//
//  ReelsViewController.m
//  StreetAttractions
//
//  Created by Xurxo Riesco on 7/28/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ReelsViewController.h"

@interface ReelsViewController ()
@end

@implementation ReelsViewController
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.pan = NO;
  self.index = 0;

  // PanGesture Set Up
  self.posts = [[NSMutableArray alloc] init];
  UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
  [self.view addGestureRecognizer:panGesture];
  [self.view setUserInteractionEnabled:YES];

  // Initial network request
  [self fetchPost];
}

#pragma mark - PanGesture Recognizer
- (void)didPan:(UIPanGestureRecognizer *)sender
{
  if (self.pan == NO) {
    CGPoint velocity = [sender velocityInView:self.view];
    // Swipe Down
    if (velocity.y > 0) {
      if (self.index > 0) {
        self.pan = YES;
        self.index -= 1;
        [self loadVideoWithIndex:self.index];
      }
      // Swipe Up
    } else if (velocity.y < -0) {
      if (self.index < self.posts.count - 1) {
        self.pan = YES;
        self.index += 1;
        [self loadVideoWithIndex:self.index];
      }
    }
  }
}

#pragma mark - Network
- (void)fetchPost
{
  PFQuery *postQuery = [Post query];
  User *user = [User currentUser];
  [postQuery includeKey:@"author"];
  [postQuery orderByDescending:@"createdAt"];
  [postQuery whereKey:@"city" equalTo:user.location];
  postQuery.limit = 20;
  [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> *_Nullable posts, NSError *_Nullable error) {
    if (posts) {
      for (Post *post in posts)
        if (post.hasVideo) {
          [self.posts addObject:post];
        }
      if (self.posts.count > 0) {
        [self loadVideoWithIndex:0];
      }
    }
  }];
}

- (void)loadVideoWithIndex:(NSInteger)index
{
  // Loading content view
  Post *post = self.posts[index];
  self.post = post;
  self.contentView.backgroundColor = [post.category colorCode];
  User *user = (User *)post.author;
  self.profilePic.file = user.profilePic;
  [self.profilePic loadInBackground];
  self.usernameLabel.text = user.screenname;
  self.profilePic.layer.masksToBounds = YES;
  self.profilePic.layer.cornerRadius = 24;

  // Loading the video itself
  PFFileObject *data = post.video;
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
      [self.view bringSubviewToFront:self.contentView];
      [self.avPlayer play];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(itemDidFinishPlaying:)
                                                   name:AVPlayerItemDidPlayToEndTimeNotification
                                                 object:[self.avPlayer currentItem]];

    } else {
      NSLog(@"Error");
    }
    self.pan = NO;
  }];
}

- (void)itemDidFinishPlaying:(NSNotification *)notification
{
  AVPlayerItem *player = [notification object];
    [self.avPlayer seekToTime:kCMTimeZero];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  DetailsViewController *detailsViewController = [segue destinationViewController];
  detailsViewController.post = self.post;
}

- (IBAction)onDetails:(id)sender
{
  [self performSegueWithIdentifier:@"toDetails" sender:nil];
}

@end
