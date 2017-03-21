//
//  OrderHistoryTableViewCell.h
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end
