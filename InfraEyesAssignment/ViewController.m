//
//  ViewController.m
//  InfraEyesAssignment
//
//  Created by Satish on 10/31/16.
//  Copyright © 2016 Satish. All rights reserved.
//

#import "ViewController.h"
#import "InfraEyesNetworkEngine.h"
#import "InfraEyesIssuesTableViewCell.h"
#import "InfraEyesIssuesModelObject.h"
#import "CommentsViewController.h"
#import "InfraEyesUtility.h"
#import "Reachability.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewObject;
@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;


@end

@implementation ViewController
{
    NSMutableArray *repoModelsArray;
    NSMutableArray *storeArray;
    UIActivityIndicatorView *activityIndicatorView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    storeArray=[[NSMutableArray alloc]init];
    [self.tableViewObject registerNib:[UINib nibWithNibName:@"InfraEyesIssuesTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfraEyesIssuesTableViewCellID"];
    [self getRepo];

    //Border For Title BackgroundView
    [_titleBackgroundView layoutIfNeeded];
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor colorWithRed:221/255.0 green:219/255.0 blue:206/255.0 alpha:0.5].CGColor;
    border.frame = CGRectMake(0, CGRectGetMaxY(self.titleBackgroundView.frame), self.titleBackgroundView.frame.size.width, 1);
    [self.titleBackgroundView.layer addSublayer:border];
    //
    
    
    activityIndicatorView =[InfraEyesUtility getActivityIndicatorView];
    activityIndicatorView.center = self.view.center;
    activityIndicatorView.hidden = NO;
    [InfraEyesUtility startAnimatingIndicator:activityIndicatorView];
    [self.view addSubview:activityIndicatorView];
    
}
-(void)getRepo{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet"
                                                        message:@"Check internet connection"
                                                       delegate:self
                                              cancelButtonTitle:@"Retry"
                                              otherButtonTitles:@"Go offline",nil];
        [alert show];
    } else {
        NSLog(@"There IS internet connection");
        [[InfraEyesNetworkEngine networkSharedManager] getallRepoDetailsWithcompletion:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (![responseObject isKindOfClass:[NSError class]]) {
                    
                    repoModelsArray = responseObject;
                    [InfraEyesUtility stopAnimatingIndicator:activityIndicatorView];
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
    
    

}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        
        [self getRepo];
    }
    else{
        
        [self getOfflineData];
        
    }
}
-(void)getOfflineData{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"IssuesList"];
    storeArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"%lu",(unsigned long)storeArray.count);
    [self.tableViewObject setHidden:NO];
    [self.tableViewObject reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
            
            repoModelsArray = storeArray;
            
            [self.tableViewObject setHidden:NO];
            [self.tableViewObject reloadData];
            
        
        
    });

}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
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
{   NSString *CellIdentifier = @"InfraEyesIssuesTableViewCellID";
    InfraEyesIssuesTableViewCell *cell = [_tableViewObject dequeueReusableCellWithIdentifier:CellIdentifier];
    InfraEyesIssuesModelObject *modelobjects=[repoModelsArray objectAtIndex:indexPath.row];
    
        cell.issueBodyLable.text=modelobjects.issueBodyObject;
        cell.issueTitleLabel.text=modelobjects.issueTitleObject;
        
    
    return cell;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    UITableViewCell *cell=nil;
    cell = [self getTableViewCellAtIndexPath:indexPath];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyBoardObject = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CommentsViewController * commentsDetailViewControllerObject = [storyBoardObject instantiateViewControllerWithIdentifier:@"CommentsViewControllerID"];
    InfraEyesIssuesModelObject *modelobjects=[repoModelsArray objectAtIndex:indexPath.row];
    commentsDetailViewControllerObject.infraEyesModelObject=modelobjects;
    
    
    [self.navigationController pushViewController:commentsDetailViewControllerObject animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
