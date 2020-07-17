//
//  PhotoMapViewController.h
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Refactored by Xurxo Riesco on 7/13/20.
//

#import <UIKit/UIKit.h>
//View Controllers
#import "LocationsViewController.h"
#import "DetailsViewController.h"
//Views
#import "Annotation.h"
#import "AnnotationPin.h"
//Models
#import "Post.h"
#import "User.h"

@import Parse;

@interface PhotoMapViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) Post *post;
@end
