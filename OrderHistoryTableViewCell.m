//
//  OrderHistoryTableViewCell.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "OrderHistoryTableViewCell.h"

@implementation OrderHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setViewCard];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setViewCard {
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 1; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(3.0f, 2.0f);
    self.layer.shadowRadius = 1;
    
    self.layer.shadowOpacity = 0.2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.imageProduct.layer.shadowPath = path.CGPath;
    
}

@end
