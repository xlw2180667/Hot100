//
//  DetailViewController.h
//  SongList
//
//  Created by 谢 砾威 on 13/04/16.
//  Copyright © 2016 谢 砾威. All rights reserved.
//

#import "ViewController.h"
#import "SonglistTableViewController.h"

@interface DetailViewController : ViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bandNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *songDescriptionLabel;

@property (nonatomic, strong) NSString *songTitle;
@property (nonatomic, strong) NSString *bandName;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *songPath;

@end
