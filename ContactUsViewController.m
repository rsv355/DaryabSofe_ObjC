//
//  ContactUsViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ContactUsViewController.h"
#import "MBProgressHUD.h"
#import "JSONHelper.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "DaryabsofeAppURL.h"

@interface ContactUsViewController () <UITextFieldDelegate>

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTextFieldLayout];
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

-(void)setTextFieldLayout {
   
    [self changeTintFor:self.txtCompany withPlaceHolder:@"Company"];
    [self changeTintFor:self.txtFirstName withPlaceHolder:@"First Name"];
    [self changeTintFor:self.txtFamilyName withPlaceHolder:@"Family Name"];
    [self changeTintFor:self.txtAddress withPlaceHolder:@"Address"];
    [self changeTintFor:self.txtLocation withPlaceHolder:@"Location"];
    [self changeTintFor:self.txtCountry withPlaceHolder:@"Country"];
    [self changeTintFor:self.txtZipcode withPlaceHolder:@"Zipcode"];
    [self changeTintFor:self.txtEmailId withPlaceHolder:@"Email Id"];
    [self changeTintFor:self.txtMessage withPlaceHolder:@"Message"];

}
-(void)changeTintFor:(UITextField *)textfield withPlaceHolder:(NSString *)placeholder {
    
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
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
    
    else if (textField != self.txtEmailId || textField == self.txtAddress) {
        
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
- (IBAction)btnSendMail:(id)sender {
    
    NSString *strCompany = [self.txtCompany text];
    NSString *strFirstName = [self.txtFirstName text];
    NSString *strFamilyName = [self.txtFamilyName text];
    NSString *strAddress = [self.txtAddress text];
    NSString *strLocation = [self.txtLocation text];
    NSString *strCountry = [self.txtCountry text];
    NSString *strZipcode = [self.txtZipcode text];
    NSString *strEmail = [self.txtEmailId text];
    NSString *strMessage = [self.txtMessage text];
    
    if (strCompany.length == 0 || strFirstName.length == 0 || strFamilyName.length == 0 || strAddress.length == 0 || strLocation.length == 0 || strCountry.length == 0 || strZipcode.length == 0 || strEmail.length == 0 || strMessage.length == 0) {
      
        [self.view makeToast:@"Please enter all fields."];
    }
    else if (strZipcode.length != 6)
    {
        [self.view makeToast:@"Please enter valid Zipcode."];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                strAddress,@"Address",
                                strCompany,@"Company",
                                strCountry,@"Country",
                                strEmail,@"Email",
                                strFamilyName,@"FamilyName",
                                strFirstName,@"FirstName",
                                strLocation,@"Location",
                                strMessage,@"Text",
                                nil];
        NSLog(@"-----%@",params);
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
        [manager POST:[NSString stringWithFormat:@"%@%@",Daryabsofe_USER_BASEURL,CONTACT_US] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSDictionary *dict = responseObject;
            [self parseDataResponse:dict];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"---->%@",error);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:@"Please check Internet connectivity."];
        }];
        
       /* NSString* WebServiceURL = [NSString stringWithFormat:@"%@%@",Daryabsofe_USER_BASEURL,CONTACT_US];
        NSString *jsonString = [[NSString alloc] init];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        NSLog(@"String is %@",jsonString);
        
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            
            // Load the JSON string from our web serivce (in a background thread)
         NSDictionary  *jsonResponse= [JSONHelper loadJSONDataFromPostURL:WebServiceURL postData:jsonString];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[SVProgressHUD dismiss];
                NSLog(@"Reply from webservice is : %@",jsonResponse);
                
        
            });
        });
        */

    }
        
}

-(void)parseDataResponse:(NSDictionary *)dictionary {
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
        
        [self resetTextFields];
    }

}

-(void)resetTextFields {

    self.txtCompany.text = @"";
    self.self.txtFirstName.text = @"";
    self.txtFamilyName.text = @"";
    self.txtAddress.text = @"";
    self.txtLocation.text = @"";
    self.txtCountry.text = @"";
    self.txtZipcode.text = @"";
    self.txtEmailId.text = @"";
    self.txtMessage.text = @"";

}
@end
