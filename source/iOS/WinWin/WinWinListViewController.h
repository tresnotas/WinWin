//
//  MyTableController.h
//  ParseStarterProject
//
//  Created by James Yu on 12/29/11.
//

#import <Parse/Parse.h>
#import "AddWinView.h"

@interface WinWinListViewController : PFQueryTableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, AddWinViewDelegate>


@end
