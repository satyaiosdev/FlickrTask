//
//  ViewController.m
//  FlickrTask
//
//  Created by atya Venkata Krishna Achanta on 14/01/17.
//  Copyright © 2017 Satya Venkata Krishna Achanta. All rights reserved.
//

#import "ViewController.h"
#import "WSGetPhotosSearch.h"
#import "TestAnnotation.h"
#import "CCHMapClusterController.h"
#import <CCHMapClusterAnnotation.h>
#import "ClusterAnnotationView.h"
#import "DetailVC.h"


@interface ViewController ()


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.mapView setDelegate:self];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    //Register a local notification 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMapUpdate:) name:@"UpdateMap" object:nil];
    
}

-(void) getPhotosSearchData{
    WSGetPhotosSearch *ws = [WSGetPhotosSearch new];
    [ws getPhotosWithSearchText:self.txtField.text];
}

-(void)handleMapUpdate:(NSNotification *)notification{
  
    self.array = [NSArray new];
    self.array = [NSArray arrayWithArray:notification.object];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self showMap];
    });
}
-(void)showMap{
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    self.mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    [self.mapClusterController addAnnotations:[self annotations] withCompletionHandler:NULL];
    
}

- (NSArray *)annotations{
    // build an NYC and SF cluster
    NSMutableArray * annotationsArray = [NSMutableArray array];
    for (int i=0; i< _array.count; i++) {
        TestAnnotation *a1 = [[TestAnnotation alloc] init];
        
        a1.coordinate = CLLocationCoordinate2DMake([[_array[i]objectForKey:@"latitude"] doubleValue]  ,[[_array[i] objectForKey:@"longitude"] doubleValue]);
        a1.imageString = [ViewController getImageUrl:[_array objectAtIndex:i]];
        a1.index = i;
        
        [annotationsArray addObject:a1];
    }
    
    return annotationsArray;
}


+(NSString *)getImageUrl:(NSDictionary *)dic{

    NSString *farm = [dic objectForKey:@"farm"];
    NSString *server = [dic objectForKey:@"server"];
    NSString *photoID = [dic objectForKey:@"photoID"];
    NSString *secret = [dic objectForKey:@"secret"];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",farm,server,photoID,secret];

    return urlStr;
    
}

// Search Button
- (IBAction)butnSearchTapped:(id)sender {
    
    if (self.txtField.text.length==0) {
        [self showAlertMessage:@"Please enter something to be searched!!"];
    }else{
        
        [self.activityIndicator startAnimating];
        [self getPhotosSearchData];
    }
    
    [_txtField resignFirstResponder];
    
}

#pragma mark - MKMapView Delegates

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    TestAnnotation *ann = ((CCHMapClusterAnnotation *)annotation).annotations.allObjects[0];
    
    
    UIImage *img =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ann.imageString]]];
    MKAnnotationView *annotationView;
    
    if ([annotation isKindOfClass:CCHMapClusterAnnotation.class]) {
        static NSString *identifier = @"clusterAnnotation";
        
        ClusterAnnotationView *clusterAnnotationView = (ClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (clusterAnnotationView) {
            clusterAnnotationView.annotation = annotation;
        } else {
            clusterAnnotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        clusterAnnotationView.canShowCallout = NO;
        clusterAnnotationView.image = img;
        
        CCHMapClusterAnnotation *clusterAnnotation = (CCHMapClusterAnnotation *)annotation;
        clusterAnnotationView.count = clusterAnnotation.annotations.count;
        clusterAnnotationView.blue = (clusterAnnotation.mapClusterController == self.mapClusterController);
        clusterAnnotationView.uniqueLocation = clusterAnnotation.isUniqueLocation;
        annotationView = clusterAnnotationView;
        annotationView.clipsToBounds = YES;
        annotationView.frame = CGRectMake(0, 0, 48,48);
        annotationView.layer.cornerRadius = annotationView.frame.size.height/2;
        annotationView.layer.masksToBounds = YES;
        annotationView.layer.borderColor = [UIColor cyanColor].CGColor;
        annotationView.layer.borderWidth=2;
        if (img) {
            clusterAnnotationView.image = img;
        }
        
    }
    
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {

    TestAnnotation *annoInfo = ((CCHMapClusterAnnotation *)view.annotation).annotations.allObjects[0];

    [self performSegueWithIdentifier:@"DVC" sender:self.array[annoInfo.index]];
    
    
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"DVC"]) {
         DetailVC *dvc = segue.destinationViewController;
         dvc.dictionary = sender;
         
     }
     
 }

#pragma mark - Alert View

-(void) showAlertMessage:(NSString *)alertMesg{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message"
                                 message:alertMesg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
