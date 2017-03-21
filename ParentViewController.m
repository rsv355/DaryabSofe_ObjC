//
//  ParentViewController.m
//  Daryabsofe
//
//  Created by Masum Chauhan on 15/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ParentViewController.h"
#import "UIButton+tintImage.h"
#import "DrawerTableViewCell.h"

@interface ParentViewController ()
{
    DrawerTableViewCell *cell;
    NSArray *identifierArr,  *titleArr;
}
@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
   
    [self.btnDrawer setImageTintColor:[UIColor colorWithRed:(172/255.0) green:(0/255.0) blue:(5/255.0) alpha:1.0f] forState:UIControlStateNormal];
    identifierArr = [[NSArray alloc]initWithObjects:@"CATEGORY",@"CART",@"ORDER_HISTORY",@"PROFILE",@"ABOUT_US",@"CONTACT_US", nil];
    titleArr = [[NSArray alloc]initWithObjects:@"Home",@"My Cart",@"Order History",@"My Profile",@"About Us",@"Contact Us", nil];
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[[NSUserDefaults standardUserDefaults]objectForKey:@"storyboardID"]];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"storyboardID"] isEqualToString:@"CATEGORY"]) {
        [self.lblHeader setText:@"Home"];
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"storyboardID"] isEqualToString:@"CART"])  {
        [self.lblHeader setText:@"My Cart"];
    }
    else {
        [self.lblHeader setText:@"Order History"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnDrawer:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"home.png"],
                        [UIImage imageNamed:@"cart.png"],[UIImage imageNamed:@"time-left.png"],
                        [UIImage imageNamed:@"profile.png"],
                        [UIImage imageNamed:@"about_us.png"],
                        [UIImage imageNamed:@"contact_us.png"],
                        [UIImage imageNamed:@"log-out.png"]
                        ];
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:nil borderColors:nil];
//    [callout setTintColor:[UIColor colorWithRed:(172/255.0) green:(0/255.0) blue:(5/255.0) alpha:0.6f]];
    
    callout.delegate = self;
    [callout show];
}
#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    
    [sidebar dismissAnimated:YES completion:nil];
    [self.view endEditing:YES];
    
    if (index == [identifierArr count]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Daryabsofe" message:@"Are you sure want to logout?" delegate:(id)self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertView setTag:2];
        [alertView show];
    
    }
    else {

        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[identifierArr objectAtIndex:index]];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        [self.containerView addSubview:vc.view];
        
        [self.lblHeader setText:[titleArr objectAtIndex:index]];

    }

}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {

}

#pragma  - Mark UIAlertview Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        if(buttonIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}


@end
