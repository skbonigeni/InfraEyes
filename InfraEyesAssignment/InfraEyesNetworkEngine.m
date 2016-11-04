//
//  InfraEyesNetworkEngine.m
//  InfraEyesAssignment
//
//  Created by Satish on 10/31/16.
//  Copyright © 2016 Satish. All rights reserved.
//

#import "InfraEyesNetworkEngine.h"
#import "InfraEyesIssuesModelObject.h"
#import "InfraEyesCommentsModelObject.h"

@import CoreData;

@implementation InfraEyesNetworkEngine
{
    NSMutableArray *commentsDataArray;
    NSMutableArray *issuesDataArray;
}
- (id) init {
    
    self = [super init];
    if (self) {
        manager = [[AFHTTPRequestOperationManager alloc] init];
        commentsDataArray=[[NSMutableArray alloc]init];
        issuesDataArray=[[NSMutableArray alloc]init];
        //Set The Requset Serializer for Content-Type
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        manager.requestSerializer = serializer;
    }
    
    
    return self;
}

+ (InfraEyesNetworkEngine *) networkSharedManager {
    
    static InfraEyesNetworkEngine *sharedManager = nil;
    
    if(!sharedManager) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[super allocWithZone:NULL] init];
        });
    }
    return sharedManager;
}
-(void)getallRepoDetailsWithcompletion:(void (^)(id responseObject))completionHandler
{
    [manager GET:[NSString stringWithFormat:@"https://api.github.com/repos/crashlytics/secureudid/issues"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success response %@",responseObject);
        completionHandler([self parseRepoDetailsFromResponseObject:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"error %@",errResponse);
        completionHandler(error);
    }];
}

-(NSMutableArray *)parseRepoDetailsFromResponseObject:(id)responseObject
{
    NSMutableArray *infraEyesModelObjects = [NSMutableArray new];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *allIssues = [[NSFetchRequest alloc] init];
    [allIssues setEntity:[NSEntityDescription entityForName:@"IssuesList" inManagedObjectContext:context]];
    [allIssues setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *issues = [context executeFetchRequest:allIssues error:&error];
    //error handling goes here
    for (NSManagedObject *issue in issues) {
        [context deleteObject:issue];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    issuesDataArray=responseObject;
    for (int i=0; i<issuesDataArray.count; i++) {
        
        InfraEyesIssuesModelObject *repoDataModelObjects=[[InfraEyesIssuesModelObject alloc]init];
        repoDataModelObjects.issueBodyObject=[NSString stringWithFormat:@"%@",[[issuesDataArray objectAtIndex:i] objectForKey:@"body"]];
        repoDataModelObjects.issueTitleObject=[NSString stringWithFormat:@"%@",[[issuesDataArray objectAtIndex:i] objectForKey:@"title"]];
        repoDataModelObjects.issueUpdatedObject=[NSString stringWithFormat:@"%@",[[issuesDataArray objectAtIndex:i] objectForKey:@"updated_at"]];
        repoDataModelObjects.issueCommentsUrlObject=[NSString stringWithFormat:@"%@",[[issuesDataArray objectAtIndex:i] objectForKey:@"comments_url"]];
        
        [infraEyesModelObjects addObject:repoDataModelObjects];
        
        //offline Data
        //1.Remove the previous data
        //2.Insert the new data
        
        
        //coredata
        
        
        // Create a new managed object
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *issuesList = [NSEntityDescription insertNewObjectForEntityForName:@"IssuesList" inManagedObjectContext:context];
        [issuesList setValue:repoDataModelObjects.issueTitleObject forKey:@"issuetitle"];
        [issuesList setValue:repoDataModelObjects.issueBodyObject forKey:@"issuebody"];
        [issuesList setValue:repoDataModelObjects.issueUpdatedObject forKey:@"issueupdated"];
        [issuesList setValue:repoDataModelObjects.issueCommentsUrlObject forKey:@"issueurl"];
        
        
        //NSError *error;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        [context save:&saveError];

    }
    return infraEyesModelObjects;
}
-(void)getallCommentsDetailsWithUrl: (NSString *)urlString withCompletion:(void (^)(id responseObject))completionHandler
{
    [manager GET:[NSString stringWithFormat:@"%@",urlString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"Success response %@",responseObject);
        completionHandler([self parseCommentsDetailsFromResponseObject:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"error %@",errResponse);
        completionHandler(error);
    }];
}
-(NSMutableArray *)parseCommentsDetailsFromResponseObject:(id)responseObject
{
    NSMutableArray *infraEyesModelObjects = [NSMutableArray new];
    commentsDataArray=responseObject;
    for (int i=0; i<commentsDataArray.count; i++) {
        
        InfraEyesCommentsModelObject *repoDataModelObjects=[[InfraEyesCommentsModelObject alloc]init];
        repoDataModelObjects.commentsBodyObject=[NSString stringWithFormat:@"%@",[[commentsDataArray objectAtIndex:i] objectForKey:@"body"]];
        repoDataModelObjects.commentsAuthorObject=[[[commentsDataArray objectAtIndex:i] objectForKey:@"user"] objectForKey:@"login"];
        
        
        [infraEyesModelObjects addObject:repoDataModelObjects];
    }
    
    return infraEyesModelObjects;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
