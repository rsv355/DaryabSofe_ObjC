//
//  ProductListViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ProductListViewController.h"
#import "CategoryTableViewCell.h"
#import "UIButton+tintImage.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "DaryabsofeAppURL.h"
#import "ProductDetailViewController.h"

@interface ProductListViewController ()
{
    CategoryTableViewCell *cell;
    NSArray  *responseArr;
    NSString *strProductID, *strUnitPrice;
}
@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.btnBack setImageTintColor:[UIColor colorWithRed:(172/255.0) green:(0/255.0) blue:(5/255.0) alpha:1.0f] forState:UIControlStateNormal];
    [self.lblHeaderName setText:_strCategoryName];
    [self.lblResponseMessage setText:@""];
    [self fetAllProductData];
    NSLog(@"------->>%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]);
   
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
    cell=(CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
       
    [cell.btnDetail setImageTintColor:[UIColor colorWithRed:(62/255.0) green:(106/255.0) blue:(39/255.0) alpha:1.0] forState:UIControlStateNormal];
    [cell.btnAddToCart setImageTintColor:[UIColor colorWithRed:(62/255.0) green:(106/255.0) blue:(39/255.0) alpha:1.0] forState:UIControlStateNormal];
    
    cell.btnDetail.tag = indexPath.row;
    cell.btnAddToCart.tag = indexPath.row;
   
    [cell.btnAddToCart addTarget:self action:@selector(btnAddToCart:) forControlEvents:UIControlEventTouchDown];
    [cell.btnDetail addTarget:self action:@selector(btnDetail:) forControlEvents:UIControlEventTouchDown];
    
    [cell.lblProductName setText:[[responseArr objectAtIndex:indexPath.row] objectForKey:@"Name"]];
    [cell.lblProductPrice setText:[NSString stringWithFormat:@"Price : $%@",[[responseArr objectAtIndex:indexPath.row] objectForKey:@"UnitPrice"]]];
    
    
    [cell.imageProduct setImageWithURL:[NSURL URLWithString:[[[[responseArr objectAtIndex:indexPath.row] objectForKey:@"lstProductImg"] objectAtIndex:0] objectForKey:@"ImagePath"]]];
    NSLog(@"%ld-----%@",(long)indexPath.row,[[[[responseArr objectAtIndex:indexPath.row] objectForKey:@"lstProductImg"] objectAtIndex:0] objectForKey:@"ImagePath"]);

    return cell;
}


#pragma -  Mark UITableView UIButton IBAction methods

-(void)btnAddToCart:(UIButton *)sender {

    strProductID = [[responseArr objectAtIndex:sender.tag] objectForKey:@"ProductID"];
    strUnitPrice =  [[responseArr objectAtIndex:sender.tag] objectForKey:@"UnitPrice"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Enter Quantity" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle =  UIAlertViewStylePlainTextInput;
    
    [alert textFieldAtIndex:0].placeholder = @"Enter Quantity";
    [alert textFieldAtIndex:0].delegate = (id)self;
    [alert textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeWhileEditing;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    
    alert.tag = 1;
    
    [alert show];
}

-(void)btnDetail:(UIButton *)sender {
    
    ProductDetailViewController *viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"PRODUCT_DETAIL"];
    
    viewController.productId = [[responseArr objectAtIndex:sender.tag] objectForKey:@"ProductID"];
    viewController.productPrice = [[responseArr objectAtIndex:sender.tag] objectForKey:@"UnitPrice"];
    viewController.productDescription = [[responseArr objectAtIndex:sender.tag] objectForKey:@"Description"];
    viewController.productName = [[responseArr objectAtIndex:sender.tag] objectForKey:@"Name"];
    viewController.productImage = [[responseArr objectAtIndex:sender.tag] objectForKey:@"lstProductImg"];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIViewController *viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"PRODUCT_DETAIL"];
    [self presentViewController:viewController animated:YES completion:nil];
}*/


#pragma - Mark UIAlertView methods

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
                [self addProduct:strProductID forQuantity:txtField.text withUnitPrice: strUnitPrice];
            }
            
        }
    }
}
- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma - Mark Consume Webservices methods

-(void) fetAllProductData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@%@%@",Daryabsofe_PRODUCT_BASEURL,PRODUCT_INFO,_strCategoryID);
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@",Daryabsofe_PRODUCT_BASEURL,PRODUCT_INFO,_strCategoryID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self parsePRODUCTDataResponse:responseDict];
    
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    

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
    NSLog(@"--->> %@",[NSString stringWithFormat:@"%@%@",Daryabsofe_ORDER_BASEURL,ADD_TO_CART]);
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];// if request JSON format
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
-(void)parsePRODUCTDataResponse :(NSDictionary *)dictionary {
    
    
    NSLog(@"------>>%@",dictionary);
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.lblResponseMessage setText:[dictionary objectForKey:@"ResponseMessage"]];
       // [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
        responseArr = [[[dictionary objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"objProductInfo"];
        [self.tableView reloadData];
       
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
