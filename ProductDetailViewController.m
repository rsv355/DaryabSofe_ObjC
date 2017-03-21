//
//  ProductDetailViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "UIButton+tintImage.h"
#import "ProductCollectionViewCell.h"
#import "ProductImageViewController.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "DaryabsofeAppURL.h"

@interface ProductDetailViewController ()
{
    ProductCollectionViewCell *cell;
}
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
        [self.btnBack setImageTintColor:[UIColor colorWithRed:(172/255.0) green:(0/255.0) blue:(5/255.0) alpha:1.0f] forState:UIControlStateNormal];
    
    self.btnUpDown.layer.cornerRadius = 15.0f;
    [self.btnUpDown setImageTintColor:[UIColor blackColor] forState:UIControlStateNormal];
    
   // [self.txtDesriptiom setText:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."];

    [self.txtDesriptiom setEditable:NO];
   
    NSString *htmlString = _productDescription;
    htmlString = [htmlString stringByAppendingString:@"<style>body{font-family:'Helvetica'; font-size:'30px';}</style>"];
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.txtDesriptiom.attributedText = attributedString;
    [self.txtDesriptiom setTextColor:[UIColor whiteColor]];
    [self.lblPrice setText:[NSString stringWithFormat:@"$%@",_productPrice]];
    [self.lblProductName setText:_productName];
    
    ProductImageViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PRODUCT_IMAGE"];
    vc.productImage = _productImage;
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)btnDescription:(id)sender {
    CGSize screenSize = self.viewDescription.frame.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    CGFloat viewHeight = self.view.frame.size.height;
    if (self.btnUpDown.tag == 0) {
        
        [self.btnUpDown setTag:1];
       
        [UIView animateWithDuration:0.8 animations:^{
            
            [self.viewDescription setFrame:CGRectMake(0, viewHeight-45, screenWidth, screenHeight)];
            
        }];
 
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:.5f];
    if( CGAffineTransformEqualToTransform( self.btnUpDown.imageView.transform, CGAffineTransformIdentity ) )
    {
        self.btnUpDown.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else {
        
        self.btnUpDown.imageView.transform = CGAffineTransformIdentity;
    }
    
    [UIView commitAnimations];

    }
    else if (self.btnUpDown.tag == 1) {
        
        [self.btnUpDown setTag:0];
       
        [UIView animateWithDuration:0.8 animations:^{
            
            [self.viewDescription setFrame:CGRectMake(0, 73, screenWidth, screenHeight)];

        }];
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:.5f];
        if( CGAffineTransformEqualToTransform( self.btnUpDown.imageView.transform, CGAffineTransformIdentity ) )
        {
            self.btnUpDown.imageView.transform = CGAffineTransformMakeRotation(M_PI*2);
        }
        else {
            
            self.btnUpDown.imageView.transform = CGAffineTransformIdentity;
        }
        
        [UIView commitAnimations];
 
    }
}
- (IBAction)btnAddToCart:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enter Quantity" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle =  UIAlertViewStylePlainTextInput;
    
    [alert textFieldAtIndex:0].placeholder = @"Enter Quantity";
    [alert textFieldAtIndex:0].delegate = (id)self;
    [alert textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
   [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    
    alert.tag = 1;
    
    [alert show];

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            UITextField *txtField = [alertView textFieldAtIndex:0];
            [txtField resignFirstResponder];
            if(txtField.text.length ==0 || [txtField.text integerValue] == 0) {
                [self.view makeToast:@"Please enter Quntity."];
            }
            else {
                [self addProduct:_productId forQuantity:txtField.text withUnitPrice: _productPrice];
            }

//            [[NSUserDefaults standardUserDefaults] setObject:@"CART" forKey:@"storyboardID"];
//            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PARENT"];
//            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}
-(void) addProduct:(NSString *)productId forQuantity:(NSString *)qunatity withUnitPrice:(NSString *)unitPrice{
    
    float totalPrice = [unitPrice floatValue] * [qunatity floatValue];
    NSString *strTotalPrice = [NSString stringWithFormat:@"%.2f",totalPrice];
    NSString *userID  = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            productId,@"ProductID",
                            qunatity,@"Qty",
                            strTotalPrice,@"TotalPrice",
                            userID,@"UserID",
                            nil];
    NSLog(@"------>>%@",params);
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
    [manager POST:[NSString stringWithFormat:@"%@%@",Daryabsofe_ORDER_BASEURL,ADD_TO_CART] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *dic1 = responseObject;
        [self parseDataResponse:dic1];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"Please check Internet connectivity."];
    }];
    
}
-(void)parseDataResponse :(NSDictionary *)dictionary {
    
    
    NSLog(@"------>>%@",dictionary);
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
        [[NSUserDefaults standardUserDefaults] setObject:@"CART" forKey:@"storyboardID"];
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PARENT"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
   
}

#pragma - mark UITextField Limit method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if([textField.text length]<4) {
        return YES;
    }
    else
        return NO;
    
}


@end
