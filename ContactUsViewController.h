//
//  ContactUsViewController.h
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtCompany;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
        @property (weak, nonatomic) IBOutlet UITextField *txtFamilyName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtZipcode;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnSendMail:(id)sender;
@end
