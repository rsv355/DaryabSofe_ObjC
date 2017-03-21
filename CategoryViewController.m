//
//  CategoryViewController.m
//  .
//
//  Created by Masum Chauhan on 15/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DaryabsofeAppURL.h"
#import "UIView+Toast.h"
#import "ProductListViewController.h"

@interface CategoryViewController ()
{
    CategoryTableViewCell *cell;
    NSArray *dataArr;
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchAllCategory];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableView DataSource and Delegate methods

- (NSUInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
   
    cell.lblCategoryName.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"Name"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductListViewController *viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"PRODUCT_LIST"];
   
    viewController.strCategoryID = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"CategoryID"];
    viewController.strCategoryName =  [[dataArr objectAtIndex:indexPath.row] objectForKey:@"Name"];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma - Mark Consume Webservices methods

-(void) fetchAllCategory {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"FETCHURL :%@%@",Daryabsofe_PRODUCT_BASEURL,GET_CATEGORY);
    
    [manager GET:[NSString stringWithFormat:@"%@%@",Daryabsofe_PRODUCT_BASEURL,GET_CATEGORY] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
    
    
    NSLog(@"------>>%@",dictionary);
    if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 0) {
        
        [self.view makeToast:[dictionary objectForKey:@"ResponseMessage"]];
    }
    else if ([[dictionary objectForKey:@"ResponseCode"] integerValue] == 1) {
        NSLog(@"----->>%@",dictionary);
        dataArr = [[[dictionary objectForKey:@"Data"] objectAtIndex:0] objectForKey:@"objLstCat"];
        [self.tableView reloadData];
    }
    
}



@end
