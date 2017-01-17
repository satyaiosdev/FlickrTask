//
//  DetailVC.h
//  FlickrTask
//
//  Created by atya Venkata Krishna Achanta on 14/01/17.
//  Copyright © 2017 Satya Venkata Krishna Achanta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDatePosted;
@property (strong, nonatomic) IBOutlet UILabel *lblOwner;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;
@property (strong, nonatomic) IBOutlet UILabel *lblLocailty;

/*!
 @brief It is NSDictionary
 
 @discussion This dictionary holds the image feed got from ViewController
 */
@property (strong,nonatomic) NSDictionary *dictionary;

@end
