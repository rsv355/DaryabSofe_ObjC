//
//  JSONHelper.h
//  DaryabSofe
//
//  Created by webmyne on 01/08/14.
//  Copyright (c) 2014 webmyne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONHelper : NSObject
+(NSDictionary *)loadJSONDataFromURL:(NSString *)urlString;
+(NSDictionary *)loadJSONDataFromPostURL:(NSString *)urlString postData :(NSString*)extra;
+(NSString *)loadJSONDataFromPostURLString:(NSString *)urlString postData :(NSString *)extra;
@end
