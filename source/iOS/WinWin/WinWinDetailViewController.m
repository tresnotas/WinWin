//
//  WinWinDetailViewController.m
//  WinWin
//
//  Created by Justin Kent on 8/24/13.
//  Copyright (c) 2013 Serdar Karatekin. All rights reserved.
//

#import "WinWinDetailViewController.h"
#import "WinWinPayPalWebViewController.h"
#import "AFJSONRequestOperation.h"

@interface WinWinDetailViewController ()

@end

@implementation WinWinDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    // Figure out if the user has already endorsed this WinWin
    PFQuery *query = [PFQuery queryWithClassName:@"Endorsement"];
    [query whereKey:@"endorser" equalTo:[PFUser currentUser]];
    [query whereKey:@"winwin" equalTo:self.winWin];
    
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        // count tells you how many objects matched the query
        NSLog(@"Existing user endorsment count: %i", count);
        if (count > 0)
        {
            self.endorseButton.enabled = NO;
            self.endorseButton.titleLabel.text = @"YOU'RE ALREADY IN";
        }
    }];
    
    // Figure out how many total people have endorsed this WinWin
    PFQuery *query2 = [PFQuery queryWithClassName:@"Endorsement"];
    [query2 whereKey:@"winwin" equalTo:self.winWin];
    
    [query2 countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        // count tells you how many objects matched the query
        NSLog(@"Existing total endorsment count: %i", count);
        if (count > 0)
        {
            self.endorseButton.enabled = NO;
            self.endorseButton.titleLabel.text = @"YOU'RE ALREADY IN";
        }
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWinWin:(PFObject *)winWin {
    _winWin = winWin;
    self.title = [winWin objectForKey:@"name"];
}

- (IBAction)imInButtonTap:(id)sender
{    
    // Create Endorsement object
    PFObject *newEndorsement = [PFObject objectWithClassName:@"Endorsement"];
    
    // Set properties
    [newEndorsement setObject:[PFUser currentUser] forKey:@"endorser"];
    [newEndorsement setObject:self.winWin forKey:@"winwin"];
    
    // Save the new Endorsement object
    [newEndorsement saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Dismiss the NewPostViewController and show the BlogTableViewController
            NSLog(@"Created new Endorsement object");
        }
    }];
    
    
    NSURL *url = [NSURL URLWithString:@"http://winwin.jit.su/getToken"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"token: %@", [JSON valueForKeyPath:@"token"]);
        //NSString *token = @"EC%2d85P9146718870862H";
        
        NSString *token = [JSON valueForKeyPath:@"token"];
        
        WinWinPayPalWebViewController *webVC = [[WinWinPayPalWebViewController alloc] init];
        
        NSString *urlString = [NSString stringWithFormat:@"https://www.sandbox.paypal.com/webscr?cmd=_express-checkout&token=%@&useraction=commit", token];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
        
        [self presentViewController:webVC animated:YES completion:NULL];
        [webVC.webView loadRequest:requestURL];
        
    } failure:nil];
    
    [operation start];
}

@end
