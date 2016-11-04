//
//  InfraEyesIssuesTableViewCell.m
//  InfraEyesAssignment
//
//  Created by Satish on 10/31/16.
//  Copyright © 2016 Satish. All rights reserved.
//

#import "InfraEyesIssuesTableViewCell.h"
#import "InfraEyesUtility.h"

@implementation InfraEyesIssuesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //Method to Calculate the preferredmaxLayoutWidth
    [InfraEyesUtility setpreferredMaxLayoutWidthToLabel:_issueBodyLable intableViewCell:self];
    [InfraEyesUtility setpreferredMaxLayoutWidthToLabel:_issueTitleLabel intableViewCell:self];
    
}

@end
