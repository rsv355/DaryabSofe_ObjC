//
//  ProfileViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 15/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ProfileViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "DaryabsofeAppURL.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewLayout];
    
    [self fetUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setViewLayout {
    
    [self changeTintFor:self.txtName withPlaceHolder:@"Name"];
    [self changeTintFor:self.txtEmail withPlaceHolder:@"Email Id"];
    [self changeTintFor:self.txtPassword withPlaceHolder:@"Password"];
    [self changeTintFor:self.txtRetypePassword withPlaceHolder:@"Retype Password"];
    [self changeTintFor:self.txtPhoneNo withPlaceHolder:@"Phone No"];
    [self changeTintFor:self.txtAddress     withPlaceHolder:@"Address"];
    [self changeTintFor:self.txtCity withPlaceHolder:@"City"];
    [self changeTintFor:self.txtState withPlaceHolder:@"State"];
    [self changeTintFor:self.txtCountry withPlaceHolder:@"Country"];
    [self changeTintFor:self.txtZipcode withPlaceHolder:@"Zipcode"];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)changeTintFor:(UITextField *)textfield withPlaceHolder:(NSString *)placeholder {
    
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
}


#pragma - Mark UIKeyboard methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentSize:CGSizeMake (self.scrollView.frame.size.width, self.scrollView.contentSize.height)];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma - mark UITextField Limit method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if (textField == self.txtAddress) {
        
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if([textField.text length]<50) {
            return YES;
        }
        else
            return NO;
    }
    
    else if (textField != self.txtEmail || textField == self.txtAddress) {
        
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


- (IBAction)btnUpdateProfile:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *strName = [self.txtName text];
    NSString *strEmailId = [self.txtEmail text];
    NSString *strPassword = [self.txtPassword text];
    NSString *strRetypePassword = [self.txtRetypePassword text];
    NSString *strPhone = [self.txtPhoneNo text];
    NSString *strAddress = [self.txtAddress text];
    NSString *strCity = [self.txtCity text];
    NSString *strState = [self.txtState text];
    NSString *strCountry = [self.txtCountry text];
    NSString *strZipcode = [self.txtZipcode text];
    
    if (strName.length == 0 || strEmailId.length == 0 || strPassword.length == 0 || strRetypePassword.length == 0 || strPhone.length == 0 || strAddress.length == 0 || strCity.length == 0 || strState.length == 0 || strCountry.length == 0 || strZipcode.length == 0) {
        
        [self.view makeToast:@"Please enter all fields"];
    }
    
    else if (![strPassword isEqualToString:strRetypePassword]) {
        [self.view makeToast:@"Password does not match."];
    }
    else if (strPhone.length <10 || strPhone.length>14) {
        [self.view makeToast:@"Enter valid Phone no."];
    }
    else if (strZipcode.length != 6) {
        [self.view makeToast:@"Enter valid Zipcode."];
    }
    else if (![self validateEmail:strEmailId]) {
        [self.view makeToast:@"Enter valid Email Id."];
    }
    else {
        //using post
        NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strAddress,@"Address",
                                strCity,@"City",
                                strEmailId,@"Email",
                                strPhone,@"Mobile",
                                @"1",@"Mode",
                                strName,@"Name",
                                strZipcode,@"PIN",
                                strPassword,@"Password",
                                strState,@"State",
                                strCountry,@"Country",
                                userID,@"UserID",
                                nil];
        NSLog(@"-------%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        [manager POST:[NSString stringWithFormat:@"%@%@",Daryabsofe_USER_BASEURL,USER_REGISTERATION] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSDictionary *dic1 = responseObject;
            [self parseDataResponseForUpdate:dic1];
        
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:@"Please check Internet connectivity."];
        }];
        
    }
    

}
-(void)parseDataResponseForUpdate:(NSDictionary *)dictionary {
   
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
}
-(void) fetUserData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@/%@/%@/%@",Daryabsofe_USER_BASEURL,USER_INFO,@"",@"",userID]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@/%@/%@/%@",Daryabsofe_USER_BASEURL,USER_INFO,@"0",@"0",userID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary  *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
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
        
        [self.txtName setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"Name"]];
        [self.txtEmail setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"Email"]];
        [self.txtPassword setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"Password"]];
        [self.txtRetypePassword setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"Password"]];
        [self.txtPhoneNo setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"Mobile"]];
        [self.txtAddress setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"Address"]];
        [self.txtCity setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"City"]];
        [self.txtState setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"State"]];
        [self.txtCountry setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"Country"]];
        [self.txtZipcode setText:[[[dictionary objectForKey:@"Data"]objectAtIndex:0] objectForKey:@"PIN"]];

        //[self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
}

@end
