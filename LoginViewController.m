//
//  LoginViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 15/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DaryabsofeAppURL.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    self.txtEmailID.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Id" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma -  Mark UIButton IBAction methods

- (IBAction)btnForgetPassword:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enter Email Id" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle =  UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"Enter Email Id";
    [alert textFieldAtIndex:0].delegate = (id)self;
    [alert textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    
    alert.tag = 1;
    
    [alert show];

}

- (IBAction)btnLogin:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *strEmail = [self.txtEmailID text];
    NSString *strPassword = [self.txtPassword text];
    
    if (strEmail.length == 0 || strPassword.length == 0) {
        
        [self.view makeToast:@"Please enter all fields."];
    }
    else if (![self validateEmail:strEmail]) {
        
        [self.view makeToast:@"Enter valid Email Id."];
    }
    else {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@/%@/%@/%@",Daryabsofe_USER_BASEURL,USER_INFO,strEmail,strPassword,@"0"]);
        
        [manager GET:[NSString stringWithFormat:@"%@%@/%@/%@/%@",Daryabsofe_USER_BASEURL,USER_INFO,strEmail,strPassword,@"0"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary  *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
            [self parseDataResponse:responseDict];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlert show];
        }];
        

    }
   

}
-(void)parseDataResponse :(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        NSString *strUserID = [[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"UserID"];
        [[NSUserDefaults standardUserDefaults] setObject:strUserID forKey:@"userID"];
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"CATEGORY" forKey:@"storyboardID"];
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PARENT"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (IBAction)btnSignup:(id)sender {
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SIGNUP"];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma - mark UITextField Limit method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if (textField != self.txtEmailID) {
        
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if([textField.text length]<20) {
            return YES;
        }
        else
            return NO;
    }
    else {
        return  YES;
    }
    
    
    
}

-(BOOL) validateEmail:(NSString*) emailString{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    ////NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0){
        return NO;
    }
    else
        return YES;
}
#pragma - Mark UIAlertView methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            UITextField *txtField = [alertView textFieldAtIndex:0];
            [txtField resignFirstResponder];
            if(txtField.text.length ==0) {
                
                [self.view makeToast:@"Please enter Email Id."];
            }
            else if (![self validateEmail:txtField.text]) {
                
                [self.view makeToast:@"Please enter valid Email Id."];
            }
            else {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                NSLog(@"FETCHURL :%@%@",Daryabsofe_USER_BASEURL,FORGET_PASSWORD);
                
                [manager GET:[NSString stringWithFormat:@"%@%@%@",Daryabsofe_USER_BASEURL,FORGET_PASSWORD,txtField.text] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary  *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   
                    [self parseDataResponseForForgetPassword:responseDict];
                   
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlert show];
                }];
                

            }
            
        }
    }
}
-(void)parseDataResponseForForgetPassword :(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
       [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
}



@end
