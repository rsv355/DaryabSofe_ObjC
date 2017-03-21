//
//  ParentViewController.h
//  Daryabsofe
//
//  Created by Masum Chauhan on 15/08/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import "RNFrostedSidebar.h"

@interface ParentViewController : ViewController<RNFrostedSidebarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnDrawer;

- (IBAction)btnDrawer:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@end
