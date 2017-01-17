//
//  ViewController.h
//  FlickrTask
//
//  Created by atya Venkata Krishna Achanta on 14/01/17.
//  Copyright © 2017 Satya Venkata Krishna Achanta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CCHMapClusterController/CCHMapClusterControllerDelegate.h>


@interface ViewController : UIViewController<MKMapViewDelegate>


/*!
 @brief It is text field
 
 @discussion This text field takes the user's search item
 */
@property (strong, nonatomic) IBOutlet UITextField *txtField;

/*!
 @brief It is a search button
 
 @discussion This button fires the search api
 */
- (IBAction)butnSearchTapped:(id)sender;

/*!
 @brief It is an apple map
 
 @discussion This map is used to display the images from Flickr API
 */
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

/*!
 @brief It is an array
 
 @discussion This array stores the feed of a search.getphotos
 */
@property (strong, nonatomic) NSArray * array;

/*!
 @brief It acts like a progress indicator.
 
 @discussion This property is activated untill all the image urls are downloaded.
 
 */
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


/*!
 @brief It is a class method that constructs the image url string.
 
 @param dictionary object
 
 */
+(NSString *)getImageUrl:(NSDictionary *)dic;

/*!
 @brief It is a map clustering helper class.
 
 @discussion This class is used to merge and divide a group of images at nearer annotations on a map respectively.
 */
@property (strong, nonatomic) CCHMapClusterController *mapClusterController;

@end

