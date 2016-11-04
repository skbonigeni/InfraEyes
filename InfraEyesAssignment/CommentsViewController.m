//
//  CommentsViewController.m
//  InfraEyesAssignment
//
//  Created by Satish on 10/31/16.
//  Copyright © 2016 Satish. All rights reserved.
//

#import "CommentsViewController.h"
#import "InfraEyesNetworkEngine.h"
#import "InfraEyesCommentsTableViewCell.h"
#import "InfraEyesCommentsModelObject.h"
#import "InfraEyesUtility.h"

@interface CommentsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewObject;
@property (weak, nonatomic) IBOutlet UIView *titleViewBackground;

@end

@implementation CommentsViewController

{
    NSMutableArray *repoModelsArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *urlString=_infraEyesModelObject.issueCommentsUrlObject;
    
    
    [self.tableViewObject registerNib:[UINib nibWithNibName:@"InfraEyesCommentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfraEyesCommentsTableViewCellID"];
    
    //Border For Title BackgroundView
    [_titleViewBackground layoutIfNeeded];
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor colorWithRed:221/255.0 green:219/255.0 blue:206/255.0 alpha:0.5].CGColor;
    border.frame = CGRectMake(0, CGRectGetMaxY(self.titleViewBackground.frame), self.titleViewBackground.frame.size.width, 1);
    [self.titleViewBackground.layer addSublayer:border];
    //
    
    UIActivityIndicatorView *activityIndicatorView =[InfraEyesUtility getActivityIndicatorView];
    activityIndicatorView.center = self.view.center;
    activityIndicatorView.hidden = NO;
    [InfraEyesUtility startAnimatingIndicator:activityIndicatorView];
    [self.view addSubview:activityIndicatorView];
    
    [[InfraEyesNetworkEngine networkSharedManager] getallCommentsDetailsWithUrl: (NSString *)urlString withCompletion:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [InfraEyesUtility stopAnimatingIndicator:activityIndicatorView];
        if (![responseObject isKindOfClass:[NSError class]]) {
            
            repoModelsArray = responseObject;
            
            
                [self.tableViewObject setHidden:NO];
                [self.tableViewObject reloadData];
            
            
        }
        else
        {
            //Failed
            
            NSError *error = responseObject;
            NSLog(@"Error****%@",error);
            [InfraEyesUtility showAlertWithMessage:error.localizedDescription];
        }
            });
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return repoModelsArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateTheHeightOfCellAtIndexPath:indexPath];
}
-(CGFloat)calculateTheHeightOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    //
    UITableViewCell *cell = [self getTableViewCellAtIndexPath:indexPath];
    
    // Configure the cell with content for the given indexPath, for example:
    // cell.textLabel.text = someTextForThisCell;
    // ...
    
    // Make sure the constraints have been set up for this cell, since it
    // may have just been created from scratch. Use the following lines,
    // assuming you are setting up constraints from within the cell's
    // updateConstraints method:
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // Set the width of the cell to match the width of the table view. This
    // is important so that we'll get the correct cell height for different
    // table view widths if the cell's height depends on its width (due to
    // multi-line UILabels word wrapping, etc). We don't need to do this
    // above in -[tableView:cellForRowAtIndexPath] because it happens
    // automatically when the cell is used in the table view. Also note,
    // the final width of the cell may not be the width of the table view in
    // some cases, for example when a section index is displayed along
    // the right side of the table view. You must account for the reduced
    // cell width.
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(_tableViewObject.bounds), CGRectGetHeight(cell.bounds));
    
    // Do the layout pass on the cell, which will calculate the frames for
    // all the views based on the constraints. (Note that you must set the
    // preferredMaxLayoutWidth on multi-line UILabels inside the
    // -[layoutSubviews] method of the UITableViewCell subclass, or do it
    // manually at this point before the below 2 lines!)
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell's contentView
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator,
    // which is added between the bottom of the cell's contentView and the
    // bottom of the table view cell.
    height += 1.0f;
    return height;
}
-(UITableViewCell *)getTableViewCellAtIndexPath:(NSIndexPath *)indexPath
{   NSString *CellIdentifier = @"InfraEyesCommentsTableViewCellID";
     InfraEyesCommentsTableViewCell *cell = [_tableViewObject dequeueReusableCellWithIdentifier:CellIdentifier];
    
    InfraEyesCommentsModelObject * modelobjects=[repoModelsArray objectAtIndex:indexPath.row];
    //cell.textLabel.text = modelobjects.commentsObject;
    cell.commentsBodyLabel.text=modelobjects.commentsBodyObject;
    cell.commentsNameLabel.text=modelobjects.commentsAuthorObject;
    
    //NSLog(@"company object %@",modelobjects.commentsBodyObject);
    return cell;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    UITableViewCell *cell=nil;
    cell = [self getTableViewCellAtIndexPath:indexPath];
    return cell;
    
}


- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
