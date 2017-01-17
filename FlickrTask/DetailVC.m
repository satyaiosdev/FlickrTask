//
//  DetailVC.m
//  FlickrTask
//
//  Created by atya Venkata Krishna Achanta on 14/01/17.
//  Copyright © 2017 Satya Venkata Krishna Achanta. All rights reserved.
//

#import "DetailVC.h"
#import "ViewController.h"
#import "WSGetImageInfo.h"

@interface DetailVC ()

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.actIndicator setHidesWhenStopped:YES];
    [self.actIndicator startAnimating];
    
    //Register a local notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleImageFeed:) name:@"UpdateImageDetail" object:nil];
    
    //Get main queue to update UI changes
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.imgDetail.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[ViewController getImageUrl:self.dictionary]]]];
        [self.actIndicator stopAnimating];
        
    });

    [self getImageFeed];
    
}

-(void)getImageFeed{
    
    WSGetImageInfo *ws = [WSGetImageInfo new];
    [ws getImageInformationWithPhotoID:[self.dictionary objectForKey:@"photoID"] andSecret:[self.dictionary objectForKey:@"secret"]];
    
}

-(void) handleImageFeed:(NSNotification *)notification{
//Get main queue to update UI changes
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.lblTitle.text = [notification.object objectForKey:@"title"];//dictionary
        self.lblDesc.text = [notification.object objectForKey:@"description"];
        self.lblOwner.text = [notification.object objectForKey:@"owner"];
        self.lblDatePosted.text = [NSString stringWithFormat:@"Taken on %@",[notification.object objectForKey:@"dateTaken"]];
        if ([notification.object objectForKey:@"locality"]) {
            self.lblLocailty.text = [NSString stringWithFormat:@"%@, %@, %@",[notification.object objectForKey:@"locality"],[notification.object objectForKey:@"region"],[notification.object objectForKey:@"country"]];
        }else{
            self.lblLocailty.text = [NSString stringWithFormat:@"%@, %@",[notification.object objectForKey:@"region"],[notification.object objectForKey:@"country"]];
        }
        
        
    });

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
