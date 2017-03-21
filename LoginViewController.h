//
//  LoginViewController.h
//  Daryabsofe
//
//  Created by Masum Chauhan on 15/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ViewController.h"

@interface LoginViewController : ViewController
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailID;

- (IBAction)btnForgetPassword:(id)sender;
- (IBAction)btnLogin:(id)sender;
- (IBAction)btnSignup:(id)sender;

@end
