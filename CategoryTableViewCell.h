//
//  CategoryTableViewCell.h
//  Daryabsofe
//
//  Created by Masum Chauhan on 15/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToCart;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;


//---CATEGORY SCREEN

@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;
@end
