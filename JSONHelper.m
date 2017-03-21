//
//  JSONHelper.m
//  DaryabSofe
//
//  Created by webmyne on 01/08/14.
//  Copyright (c) 2014 webmyne. All rights reserved.
//

#import "JSONHelper.h"

@implementation JSONHelper


+(NSDictionary *)loadJSONDataFromURL:(NSString *)urlString
{
    // This function takes the URL of a web service, calls it, and either returns "nil", or a NSDictionary,
    // describing the JSON data that was returned.
    //
    
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
    if (!data)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        return nil;
    }
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (dictionary == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    return dictionary;
}

+(NSDictionary *)loadJSONDataFromPostURL:(NSString *)urlString postData :(NSString *)extra
{
    // This function takes the URL of a web service, calls it, and either returns "nil", or a NSDictionary,
    // describing the JSON data that was returned.
    //
    
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // help to post data in JSON format

  [request setHTTPBody:[NSData dataWithBytes:[extra UTF8String] length:[extra length]]];


    
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
    if (!data)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        return nil;
    }
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (dictionary == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    return dictionary;
}

+(NSString *)loadJSONDataFromPostURLString:(NSString *)urlString postData :(NSString *)extra
{
    // This function takes the URL of a web service, calls it, and either returns "nil", or a NSString,
    // describing the JSON data that was returned.
    //
    
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // help to post data in JSON format
    
    [request setHTTPBody:[NSData dataWithBytes:[extra UTF8String] length:[extra length]]];
    
    
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
    NSLog(@"data contents: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    if (!data)
    {
        NSLog(@"Download Error: %@", error.localizedDescription);
        return nil;
    }
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    NSString *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (dictionary == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    return dictionary;
}

@end
