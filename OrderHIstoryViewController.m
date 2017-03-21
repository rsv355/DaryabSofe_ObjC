//
//  OrderHIstoryViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "OrderHIstoryViewController.h"
#import "OrderHistoryTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DaryabsofeAppURL.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+Toast.h"

@interface OrderHIstoryViewController ()
{
    OrderHistoryTableViewCell *cell;
    NSDictionary *orderDict;
    NSArray *orderTitleArr;
}
@end


@implementation OrderHIstoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewEmptyOrder.hidden = YES;
    [self fetchOrderHistoryData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [orderTitleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   // NSLog(@"---->> %ld",[[[orderTitleArr objectAtIndex:section] objectForKey:@"lstOrderedProducts"] count]);
    
    return [[[orderTitleArr objectAtIndex:section] objectForKey:@"lstOrderedProducts"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[orderTitleArr objectAtIndex:section] objectForKey:@"OrderNo"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
    cell.lblProductName.text = [[[[orderTitleArr objectAtIndex:indexPath.section] objectForKey:@"lstOrderedProducts"] objectAtIndex:indexPath.row] objectForKey:@"ProductName"];
   
    cell.lblTime.text = [[orderTitleArr objectAtIndex:indexPath.section] objectForKey:@"OrderDate"];
    
    cell.lblQuantity.text = [NSString stringWithFormat:@"Quantity : %@",[[[[orderTitleArr objectAtIndex:indexPath.section] objectForKey:@"lstOrderedProducts"] objectAtIndex:indexPath.row] objectForKey:@"Quantity"]];
   
    cell.lblPrice.text = [NSString stringWithFormat:@"Unit Price : $%@",[[[[orderTitleArr objectAtIndex:indexPath.section] objectForKey:@"lstOrderedProducts"] objectAtIndex:indexPath.row] objectForKey:@"UnitPrice"]];

    [cell.imageProduct setImageWithURL:[NSURL URLWithString:[[[[orderTitleArr objectAtIndex:indexPath.section] objectForKey:@"lstOrderedProducts"] objectAtIndex:indexPath.row] objectForKey:@"ProductImage"]]];
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)] ;
     [headerView setBackgroundColor:[UIColor colorWithRed:(213/255.0) green:(221/255.0) blue:(36/255.0) alpha:0.9]];
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(8, 4, headerView.frame.size.width, 20)];
    [lblTitle setFont:[UIFont fontWithName:@"Helvetica-Neue Medium" size:16]];
    [lblTitle setText:[[orderTitleArr objectAtIndex:section] objectForKey:@"OrderNo"]];
    [headerView addSubview:lblTitle];
    return headerView;
}

-(void)fetchOrderHistoryData {
    
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@",[NSString stringWithFormat:@"%@%@%@",Daryabsofe_ORDER_BASEURL,ORDER_HISTORY,userID]);
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@",Daryabsofe_ORDER_BASEURL,ORDER_HISTORY,userID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        
        if ([[dictionary objectForKey:@"Data"] count] == 0) {
           
            self.viewEmptyOrder.hidden = NO;
            //[self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
        }
        else {
            orderTitleArr = [dictionary objectForKey:@"Data"];
            NSLog(@"--->>%ld",(long)[orderTitleArr count]);
            for(int i=0; i<[orderTitleArr count]; i++) {
               // NSLog(@"----->> %@",[[orderTitleArr objectAtIndex:i] objectForKey:@"OrderDate"]);
                 NSLog(@"----->>%ld",(long)[[[orderTitleArr objectAtIndex:i] objectForKey:@"lstOrderedProducts"] count]);
            }
            [self.tableView reloadData];
        }
       
    }
    
}

@end
