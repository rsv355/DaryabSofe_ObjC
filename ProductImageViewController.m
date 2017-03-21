//
//  ProductImageViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 17/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ProductImageViewController.h"
#import "ProductCollectionViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface ProductImageViewController ()
{
    ProductCollectionViewCell *cell;
}
@end

@implementation ProductImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     NSLog(@"Images ---->> %@",_productImage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_productImage count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell.productImage setImageWithURL:[NSURL URLWithString:[[_productImage objectAtIndex:indexPath.row] objectForKey:@"ImagePath"]]];

    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    CGSize collectionviewSize=self.collectionView.frame.size;
    side1=collectionviewSize.width-30;
    side2=collectionviewSize.height;
    return CGSizeMake(side1, side2);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


@end
