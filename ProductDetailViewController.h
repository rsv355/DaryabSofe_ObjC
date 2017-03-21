//
//  ProductDetailViewController.h
//  Daryabsofe
//
//  Created by Masum Chauhan on 16/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnUpDown;
- (IBAction)btnDescription:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewDescription;

@property (weak, nonatomic) IBOutlet UITextView *txtDesriptiom;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToCart;
- (IBAction)btnAddToCart:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productPrice;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSArray *productImage;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@end
