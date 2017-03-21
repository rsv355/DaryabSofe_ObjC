//
//  ProductImageViewController.h
//  Daryabsofe
//
//  Created by Masum Chauhan on 17/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *productImage;
@end
