//
//  WSGetPhotosSearch.h
//  FlickrTask
//
//  Created by atya Venkata Krishna Achanta on 14/01/17.
//  Copyright © 2017 Satya Venkata Krishna Achanta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSGetPhotosSearch : NSObject<NSURLSessionDelegate>

- (void)getPhotosWithSearchText:(NSString *)str;

@end
