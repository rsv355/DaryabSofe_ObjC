//
//  ProductListViewController.h
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ProductListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSString *strCategoryID;
@property (strong,nonatomic) NSString *strCategoryName;

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderName;
@property (weak, nonatomic) IBOutlet UILabel *lblResponseMessage;

@end
