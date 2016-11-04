//
//  InfraEyesUtility.h
//  InfraEyesAssignment
//
//  Created by Satish on 11/1/16.
//  Copyright © 2016 Satish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface InfraEyesUtility : NSObject
+(UIActivityIndicatorView *)getActivityIndicatorView;
+(void)startAnimatingIndicator:(UIActivityIndicatorView *)activityIndicatorView;
+(void)stopAnimatingIndicator:(UIActivityIndicatorView *)activityIndicatorView;

+(void)showAlertWithMessage:(NSString *)message;

+ (void)addBottomBorderToView:(UIView *)headerView;
+ (void)addTopBorderToView:(UIView *)headerView;

+(void)setpreferredMaxLayoutWidthToLabel:(UILabel *)label intableViewCell:(UITableViewCell *)cell;
@end
