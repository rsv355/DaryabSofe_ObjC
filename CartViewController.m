//
//  CartViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "UIButton+tintImage.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "DaryabsofeAppURL.h"
#import "PayPalMobile.h"

@interface CartViewController ()
{
    CartTableViewCell *cell;
    NSArray  *responseArr;
    NSString *strProductID, *strUnitPrice, *strOrderID, *strTotalCost;
    
}

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.lblPayableAmount.text =@"";
    self.viewEmptyCart.hidden = YES;
    
    self.lblTotal.hidden = YES;
    self.btnProceedToCheckout.hidden = YES;
    [self fetAllCartProducts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UITableView DataSource and Delegate methods

- (NSUInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [responseArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(CartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell.btnEdit setImageTintColor:[UIColor colorWithRed:(62/255.0) green:(106/255.0) blue:(39/255.0) alpha:1.0] forState:UIControlStateNormal];
    [cell.btnDelete setImageTintColor:[UIColor colorWithRed:(62/255.0) green:(106/255.0) blue:(39/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(btnEditProductQuantity:) forControlEvents:UIControlEventTouchDown];
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(btnDeleteProduct:) forControlEvents:UIControlEventTouchDown];

    cell.lblProductName.text = [[responseArr objectAtIndex:indexPath.row] objectForKey:@"ProductName"];
    cell.lblPrice.text = [NSString stringWithFormat:@"Unit Price : $%@",[[responseArr objectAtIndex:indexPath.row] objectForKey:@"UnitPrice"]];
    cell.lblQuantity.text = [NSString stringWithFormat:@"Quantity : %@",[[responseArr objectAtIndex:indexPath.row] objectForKey:@"Quantity"]];
    [cell.imageProduct setImageWithURL:[NSURL URLWithString:[[responseArr objectAtIndex:indexPath.row] objectForKey:@"ProductImage"]]];
    
    strOrderID =[[responseArr objectAtIndex:indexPath.row] objectForKey:@"OrderID"];
    
    return cell;
}

- (IBAction)btnEditProductQuantity:(UIButton *)sender {
    
    strProductID = [[responseArr objectAtIndex:sender.tag] objectForKey:@"ProductID"];
    strUnitPrice = [[responseArr objectAtIndex:sender.tag] objectForKey:@"UnitPrice"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enter Quantity" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle =  UIAlertViewStylePlainTextInput;
    
    [alert textFieldAtIndex:0].placeholder = @"Enter Quantity";
    [alert textFieldAtIndex:0].delegate = (id)self;
    [alert textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    
    alert.tag = 1;
    
    [alert show];
    
}

-(IBAction)btnDeleteProduct:(UIButton *)sender {
    
    strProductID = [[responseArr objectAtIndex:sender.tag] objectForKey:@"ProductID"];
    strOrderID = [[responseArr objectAtIndex:sender.tag] objectForKey:@"OrderID"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to delete?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 2;
    
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
                [self addProduct:strProductID forQuantity:txtField.text withUnitPrice:strUnitPrice];
            }
        }
    }
   else if(alertView.tag == 2)
    {
        if(buttonIndex == 1)
        {
            [self deleteProductFromCart:strProductID];
        }
    }
    else if(alertView.tag == 3)
    {
        if(buttonIndex == 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"ORDER_HISTORY" forKey:@"storyboardID"];
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PARENT"];
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
    
    
}



#pragma mark - Consume Webservices methods

-(void) fetAllCartProducts {
    
    NSString *userID  = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@%@%@",Daryabsofe_ORDER_BASEURL, FETCH_CART, userID);
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@",Daryabsofe_ORDER_BASEURL, FETCH_CART, userID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        [self parseDataResponse:responseDict];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    
    
}
-(void)parseDataResponse :(NSDictionary *)dictionary {
  
     NSLog(@"CART------->>%@",dictionary);
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
       
        if ([[dictionary objectForKey:@"Data"] count] == 0) {
            self.viewEmptyCart.hidden = NO;
            //[self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
        }
        else {
            self.lblTotal.hidden = NO;
            self.btnProceedToCheckout.hidden = NO;
            responseArr = [[[dictionary objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"lstOrderedProducts"];
            
            self.lblPayableAmount.text = [NSString stringWithFormat:@"$%@",[[[dictionary objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"PayableAmount"]];
            strTotalCost = [[[dictionary objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"PayableAmount"];
            [self.tableView reloadData];
        }
        
    }
    
    /*
     [[NSUserDefaults standardUserDefaults] setObject:@"CART" forKey:@"storyboardID"];
     UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PARENT"];
     [self presentViewController:viewController animated:YES completion:nil];
     
     */
}

-(void) addProduct:(NSString *)productId forQuantity:(NSString *)qunatity  withUnitPrice:(NSString *)unitPrice {
    
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
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer = [AFJSONResponseSerializer serializer];// if request JSON format
    [manager POST:[NSString stringWithFormat:@"%@%@",Daryabsofe_ORDER_BASEURL,ADD_TO_CART] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *dic1 = responseObject;
        [self parseDataResponseForEdit:dic1];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.view makeToast:@"Please check Internet connectivity."];
    }];
    
}
-(void)parseDataResponseForEdit :(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
        [self viewDidLoad];
    }
    
}


-(void) deleteProductFromCart:(NSString *)productID {
    
    NSString *userID  = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@%@%@/%@/%@",Daryabsofe_ORDER_BASEURL, REMOVE_CART, strOrderID, productID, userID);
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@/%@/%@",Daryabsofe_ORDER_BASEURL, REMOVE_CART, strOrderID, productID, userID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"------>> %@",responseDict);
        [self parseDataResponse:responseDict];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    
    
}

- (IBAction)btnProceedToCheckout:(id)sender {
    NSLog(@"------->> %@",strOrderID);
    [self startpayment:[NSString stringWithFormat:@"%@",strOrderID]];
    
}

-(void)PaymentStatusSendToServer:(NSString *)transactionID {
    
    NSLog(@"Transaction ID-------->> %@",transactionID);
    
    NSString *userID  = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@%@%@/%@/%@",Daryabsofe_ORDER_BASEURL, PLACE_ORDER, strOrderID, userID,transactionID);
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@/%@/%@",Daryabsofe_ORDER_BASEURL, PLACE_ORDER, strOrderID, userID,transactionID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"------>> %@",responseDict);
        [self parseDataResponseForPlaceOrder:responseDict];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];

}
-(void)parseDataResponseForPlaceOrder :(NSDictionary *)dictionary {
    
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"THANK YOU" message:[dictionary objectForKey:@"ResponseMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = 3;
        [alert show];
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

#pragma mark PayPal

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Mohi Miralai";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://sandbox.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://sandbox.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    _payPalConfig.presentingInPopover=YES;
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    // *************Set enviornment to production by using"" "PayPalEnvironmentProduction"****************************
    self.environment = PayPalEnvironmentSandbox;//
    self.view.userInteractionEnabled=YES;
    [self setPayPalEnvironment:self.environment];
    
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}


-(void)startpayment:(NSString *)orderId
{
    self.resultText = nil;
    NSMutableArray *shoppingItem=[[NSMutableArray alloc]init];
    
    
  
        PayPalItem *item = [PayPalItem itemWithName:@"Daryabsofe Item"
                                       withQuantity:1
                                          withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",strTotalCost]]
                                       withCurrency:@"USD"
                                            withSku:@"Hapee"];//Add product that you want to sell if it is multiple use loop to add into shopping items
        [shoppingItem addObject:item];
        
    
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:shoppingItem];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal  withShipping:shipping withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Total";
    payment.items = shoppingItem;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    payment.invoiceNumber=orderId;// order Id to be set here********************
    
    if (!payment.processable) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Payment Can not be made at this movement." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    // Update payPalConfig re accepting credit cards.
    _payPalConfig.presentingInPopover=YES;
    
    self.payPalConfig.acceptCreditCards = YES;
    self.payPalConfig.disableBlurWhenBackgrounding=YES;
    [[UINavigationBar appearance] setTintColor:nil];
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    
    
    [paymentViewController.view bringSubviewToFront:paymentViewController.view];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
}


#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    
    NSLog(@"PayPal Payment Success!");
    // [ self  PayNowAPI ];
    self.resultText = [completedPayment description];
    //  [self showSuccess];
    NSLog(@"self.resultText %@",self.resultText);
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    NSLog(@"self.resultText 2 %@",self.resultText);
    //   self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view makeToast:@"Payment Canceled"];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSDictionary *res=completedPayment.confirmation;
    NSDictionary *respDict=[res objectForKey:@"response"];
    NSLog(@"pay pal resp %@",respDict);
    
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    NSString *transactionID = [respDict objectForKey:@"id"];
    [self PaymentStatusSendToServer:transactionID];

}





@end
