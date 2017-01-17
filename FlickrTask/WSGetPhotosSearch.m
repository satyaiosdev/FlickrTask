//
//  WSGetPhotosSearch.m
//  FlickrTask
//
//  Created by atya Venkata Krishna Achanta on 14/01/17.
//  Copyright © 2017 Satya Venkata Krishna Achanta. All rights reserved.
//

#import "WSGetPhotosSearch.h"
#import "ViewController.h"

#define API_KEY @"0f19822c0b690fc34a2992a527bafacc"
//#define SECRET_KEY @"a355ec542982cf11" >>>>Secret Key is fetched dynamically<<<<

NSMutableArray *arrayWithLatLong;
int arrayCount;
@implementation WSGetPhotosSearch

//Getting 200 images per search statically//
- (void)getPhotosWithSearchText:(NSString *)searchStr
{
    
 NSString * ip_addrs=[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&has_geo=1&per_page=200&page=1&format=json&nojsoncallback=1",API_KEY,searchStr];
    
    
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
                                          NSLog(@"%@",dic);

                                          NSArray *array = [dic valueForKeyPath:@"photos.photo"];
                                          NSMutableArray *mArray = [NSMutableArray new];
                                          NSMutableDictionary *dict;
                                          for (NSDictionary *d in array) {
                                              dict =[NSMutableDictionary new];
                                              [dict setObject:[d valueForKey:@"farm"] forKey:@"farm"];
                                              [dict setObject:[d valueForKey:@"id"] forKey:@"photoID"];
                                              [dict setObject:[d valueForKey:@"owner"] forKey:@"owner"];
                                              [dict setObject:[d valueForKey:@"secret"] forKey:@"secret"];
                                              [dict setObject:[d valueForKey:@"server"] forKey:@"server"];
                                              [mArray addObject:dict];

                                              
                                          }
              
//                                       NSLog(@"it is array length:%ld", mArray.count);
                                          arrayCount = (int)mArray.count;
                                          
                                          for(int i=0; i<mArray.count; i++){
                                             
                                              [self getPhotosLocationWithCompletionHandler:mArray[i]];
                                          }
                                          
                                      }];
    
    [dataTask resume];
    
    
}

- (void)getPhotosLocationWithCompletionHandler:(NSMutableDictionary *)dictObj
{
    arrayWithLatLong = [NSMutableArray new];
    NSString * ip_addrs=[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=%@&photo_id=%@&format=json&nojsoncallback=1",API_KEY,[dictObj objectForKey:@"photoID"]];
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
                                          
                                        NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
                                        
                                        [dictObj setObject:[responseDic valueForKeyPath:@"photo.location.latitude"] forKey:@"latitude"];
                                        [dictObj setObject:[responseDic valueForKeyPath:@"photo.location.longitude"] forKey:@"longitude"];
                                        [arrayWithLatLong addObject:dictObj];

                                          if (arrayCount == arrayWithLatLong.count) {
                                              //post notification
                                              
                                              [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateMap" object:arrayWithLatLong];
                                              
                                          }
                                          
                                      }];
    
    [dataTask resume];
    
    
}


@end
