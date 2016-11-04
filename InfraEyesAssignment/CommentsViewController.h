//
//  CommentsViewController.h
//  InfraEyesAssignment
//
//  Created by Satish on 10/31/16.
//  Copyright © 2016 Satish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfraEyesIssuesModelObject.h"
@interface CommentsViewController : UIViewController
@property(strong,nonatomic) InfraEyesIssuesModelObject *infraEyesModelObject;
- (IBAction)backButtonAction:(id)sender;

@end
