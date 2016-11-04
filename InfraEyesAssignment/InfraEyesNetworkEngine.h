//
//  InfraEyesNetworkEngine.h
//  InfraEyesAssignment
//
//  Created by Satish on 10/31/16.
//  Copyright © 2016 Satish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface InfraEyesNetworkEngine : NSObject
{
    AFHTTPRequestOperationManager *manager;
}
+ (InfraEyesNetworkEngine *) networkSharedManager;

-(void)getallRepoDetailsWithcompletion:(void (^)(id responseObject))completionHandler;
-(void)getallCommentsDetailsWithUrl: (NSString *)urlString withCompletion:(void (^)(id responseObject))completionHandler;
@end
