//
//  SonglistTableViewController.h
//  SongList
//
//  Created by 谢 砾威 on 13/04/16.
//  Copyright © 2016 谢 砾威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SonglistTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tblSonglist;

@property (nonatomic, strong) NSArray *arraySonglistInfo;

@end
