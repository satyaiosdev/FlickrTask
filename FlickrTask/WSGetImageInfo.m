//
//  WSGetImageInfo.m
//  FlickrTask
//
//  Created by atya Venkata Krishna Achanta on 16/01/17.
//  Copyright © 2017 Satya Venkata Krishna Achanta. All rights reserved.
//

#import "WSGetImageInfo.h"

#define API_KEY @"0f19822c0b690fc34a2992a527bafacc"

@implementation WSGetImageInfo

-(void) getImageInformationWithPhotoID:(NSString *)imgID andSecret:(NSString *)secret{
    
    NSString * ip_addrs=[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&secret=%@&format=json&nojsoncallback=1",API_KEY,imgID,secret];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ip_addrs]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error) {
                                              NSLog(@"dataTaskWithRequest error: %@", error);
                                              return;
                                          }
                                          
                                          NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
                                        
                                          
                                          NSMutableDictionary *dict = [NSMutableDictionary new];
                                          
                                          [dict setObject:[dic valueForKeyPath:@"photo.dates.taken"] forKey:@"dateTaken"];
                                          [dict setObject:[dic valueForKeyPath:@"photo.description._content"] forKey:@"description"];
                                          [dict setObject:[dic valueForKeyPath:@"photo.location.country._content"] forKey:@"country"];
                                          [dict setObject:[dic valueForKeyPath:@"photo.owner.username"] forKey:@"owner"];
                                          [dict setObject:[dic valueForKeyPath:@"photo.title._content"] forKey:@"title"];
                                          
                                          if ([dic valueForKeyPath:@"photo.location.locality._content"]!=error)// checking for error data in locality
                                          {
                                              [dict setObject:[dic valueForKeyPath:@"photo.location.locality._content"] forKey:@"locality"];
                                          }
                                          if ([dic valueForKeyPath:@"photo.location.region._content"]!=error) {
                                              [dict setObject:[dic valueForKeyPath:@"photo.location.region._content"] forKey:@"region"];
                                          }
                                          
                                          NSLog(@"Image Feed:%@",dict);

                                          [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateImageDetail" object:dict];
              
                                      }];
    [dataTask resume];
    

    
    
}


@end
