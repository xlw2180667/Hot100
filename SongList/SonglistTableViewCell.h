//
//  SonglistTableViewCell.h
//  SongList
//
//  Created by 谢 砾威 on 18/04/16.
//  Copyright © 2016 谢 砾威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SonglistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@end
