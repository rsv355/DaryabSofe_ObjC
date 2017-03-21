//
//  AboutUsViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DaryabsofeAppURL.h"
#import "UIView+Toast.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.txtAboutUs setEditable:NO];
    [self.txtAboutUs setText:@""];
    [self fetchAboutUsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchAboutUsData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@%@",Daryabsofe_USER_BASEURL,ABOUT_US);
    
    [manager GET:[NSString stringWithFormat:@"%@%@",Daryabsofe_USER_BASEURL,ABOUT_US] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
     NSDictionary   *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
    [self parseDataResponse:responseDict];
        
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];

}
-(void)parseDataResponse :(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        NSString *htmlString = [[[dictionary objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"AboutContent"];
        htmlString = [htmlString stringByAppendingString:@"<style>body{font-family:'Helvetica'; font-size:'30px';}</style>"];
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        self.txtAboutUs.attributedText = attributedString;
        [self.txtAboutUs setTextColor:[UIColor colorWithRed:(62/255.0) green:(106/255.0) blue:(39/255.0) alpha:1.0]];
        
    }
}


@end
