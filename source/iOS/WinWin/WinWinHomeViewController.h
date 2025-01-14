//
//  WinWinHomeViewController.h
//  WinWin
//
//  Created by Serdar Karatekin on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PayPalMobile.h"

@interface WinWinHomeViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, PayPalPaymentDelegate>

@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIView *addWinsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addWinsViewHeightConstraint;

- (IBAction)logOutButtonTapAction:(id)sender;
- (IBAction)paypalButtonTapAction:(id)sender;
- (IBAction)tapAdd:(id)sender;


@end
