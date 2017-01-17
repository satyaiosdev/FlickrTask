//
//  WSGetImageInfo.h
//  FlickrTask
//
//  Created by atya Venkata Krishna Achanta on 16/01/17.
//  Copyright © 2017 Satya Venkata Krishna Achanta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSGetImageInfo : NSObject<NSURLSessionDelegate>

-(void) getImageInformationWithPhotoID:(NSString *)imgID andSecret:(NSString *)secret;

@end
