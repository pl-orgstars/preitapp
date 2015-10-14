//
//  MessagesCell.m
//  Preit
//
//  Created by Jawad Ahmed on 10/14/15.
//
//

#import "MessagesCell.h"

@implementation MessagesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_cellLabel release];
    [super dealloc];
}
@end
