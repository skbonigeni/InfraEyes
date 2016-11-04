//
//  InfraEyesUtility.m
//  InfraEyesAssignment
//
//  Created by Satish on 11/1/16.
//  Copyright © 2016 Satish. All rights reserved.
//

#import "InfraEyesUtility.h"

@implementation InfraEyesUtility
#pragma mark Method to Show The Activity Indicator
+(UIActivityIndicatorView *)getActivityIndicatorView
{
    UIActivityIndicatorView *activityIndicatorViewObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return activityIndicatorViewObject;
}
#pragma mark Methods to Animate The Indicator
+(void)startAnimatingIndicator:(UIActivityIndicatorView *)activityIndicatorView
{
    activityIndicatorView.hidden = NO;
    [activityIndicatorView startAnimating];
    
}
+(void)stopAnimatingIndicator:(UIActivityIndicatorView *)activityIndicatorView
{
    activityIndicatorView.hidden = YES;
    [activityIndicatorView stopAnimating];
    
}
//+ (void)addBottomBorderToView:(UIView *)headerView {
//
//    UIColor *colorObject = [UIColor redColor];
//    CGFloat borderWidth = 0.5;
//
//    CALayer *border = [CALayer layer];
//    border.backgroundColor = colorObject.CGColor;
//
//    border.frame = CGRectMake(0, headerView.frame.size.height - borderWidth, headerView.frame.size.width, borderWidth);
//    [headerView.layer addSublayer:border];
//}


#pragma mark Method for Generic AlertView
+(void)showAlertWithMessage:(NSString *)message;
{
    if ([UIAlertController class]) {
        // use UIAlertController
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Toppr"  message:message  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[InfraEyesUtility getCurrentNavigationController] dismissViewControllerAnimated:YES completion:nil];
        }]];
        [[InfraEyesUtility getCurrentNavigationController] presentViewController:alertController animated:YES completion:nil];
        
    } else {
        // use UIAlertView
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Toppr" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}
#pragma mark Method to get the Top Most (i.e Visible) ViewController

+ (UIViewController *)getCurrentNavigationController
{
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    UIViewController *currentViewController;
    
    if ([appDelegate.window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        currentViewController = ((UINavigationController*)appDelegate.window.rootViewController).visibleViewController;
        
    }
    else if ([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        currentViewController = ((UITabBarController*)appDelegate.window.rootViewController).selectedViewController;
        
    }
    
    return currentViewController;
}

+ (void)addBottomBorderToView:(UIView *)headerView {
    
    UIColor *colorObject = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    //UIColor *colorObject = [UIColor whiteColor];
    CGFloat borderWidth = 0.5;
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = colorObject.CGColor;
    
    border.frame = CGRectMake(0, headerView.frame.size.height - borderWidth, headerView.frame.size.width, borderWidth);
    [headerView.layer addSublayer:border];
}
+ (void)addTopBorderToView:(UIView *)headerView {
    
    UIColor *colorObject = [UIColor greenColor];
    CGFloat borderWidth = 0.5;
    
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = colorObject.CGColor;
    
    border.frame = CGRectMake(0, 0, headerView.frame.size.width, borderWidth);
    [headerView.layer addSublayer:border];
}

#pragma mark Method to Set The preferredMaxLayoutWidth
+(void)setpreferredMaxLayoutWidthToLabel:(UILabel *)label intableViewCell:(UITableViewCell *)cell
{
    cell.contentView.frame = cell.bounds;
    cell.selectedBackgroundView.frame = cell.bounds;
    
    [label updateConstraintsIfNeeded];
    [label layoutIfNeeded];
    
    label.preferredMaxLayoutWidth = label.bounds.size.width;
}

@end
