//
//  PhotoMapViewController.h
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

@import Parse;
#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

//View Controllers
#import "LocationsViewController.h"
#import "DetailsViewController.h"

//Views
#import "Annotation.h"
#import "AnnotationPin.h"
//Models

#import "Post.h"
#import "User.h"


@interface PhotoMapViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UIView *weatherBorder;
@property (nonatomic, strong) Post *post;
@end
