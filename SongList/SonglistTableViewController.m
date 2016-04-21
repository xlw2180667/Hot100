//
//  songlistTableViewController.m
//  SongList
//
//  Created by 谢 砾威 on 13/04/16.
//  Copyright © 2016 谢 砾威. All rights reserved.
//

#import "SonglistTableViewController.h"
#import "SongListDatabase.h"
#import "DetailViewController.h"
#import "SonglistTableViewCell.h"

@interface SonglistTableViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) SongListDatabase *database;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

- (void) loadData;

@end

@implementation SonglistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set the delegate and data source to the table view
    self.tblSonglist.delegate = self;
    self.tblSonglist.dataSource = self;
    //Initialize the database
    self.database = [[SongListDatabase alloc] initWithDatabasefileName:@"song_list.sqlite3"];
    [self loadData];
    //Initialize the search controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.definesPresentationContext = YES;

    [self.searchController.searchBar sizeToFit];
    //Add the search bar to the head of the table view
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Hide the search bar unless the user scrolls up the table view
    CGPoint contentOffSet = self.tableView.contentOffset;
    contentOffSet.y += CGRectGetHeight(self.tableView.tableHeaderView.frame);
    self.tableView.contentOffset = contentOffSet;
}

- (void) loadData {
    //The query statement
    NSString *query = @"SELECT * FROM song_list";
    //Initialize the songlist infomation array
    if (self.arraySonglistInfo != nil) {
        self.arraySonglistInfo = nil;
    }
    self.arraySonglistInfo = [[NSArray alloc] initWithArray:[self.database loadingDataFromDatabase:query]];
    //Reload the data to the table view
    [self.tblSonglist reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Set the number of the rows of the table view
    if (self.searchController.active) {
        return self.searchResults.count;
    } else {
        return self.arraySonglistInfo.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Set the height fo table view cell
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Initialize the cell with identifier
    SonglistTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];

    //The objects in which row of the result array
    NSInteger uniqueId = [self.database.arrayColumnNames indexOfObject:@"id"];
    NSInteger title = [self.database.arrayColumnNames indexOfObject:@"title"];
    NSInteger bandName = [self.database.arrayColumnNames indexOfObject:@"bandName"];
    NSInteger picture = [self.database.arrayColumnNames indexOfObject:@"pictureName"];
    //This array contents the search results or the whole songlist.
    NSArray *songlist = nil;
    if (self.searchController.active) {
        songlist = self.searchResults;
    } else {
        songlist = self.arraySonglistInfo;
    }
    //Set the cell objects
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",[[songlist objectAtIndex:indexPath.row] objectAtIndex:title]];
    cell.rankLabel.text = [NSString stringWithFormat:@"%@",[[songlist objectAtIndex:indexPath.row] objectAtIndex:uniqueId]];
    cell.thumbnailImageView.image = [UIImage imageNamed:[[songlist objectAtIndex:indexPath.row] objectAtIndex:picture]];
    cell.bandNameLabel.text = [NSString stringWithFormat:@"%@", [[songlist objectAtIndex:indexPath.row] objectAtIndex:bandName]];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //Push the data to the detail view controller
        DetailViewController *detailViewController = segue.destinationViewController;
        NSInteger title = [self.database.arrayColumnNames indexOfObject:@"title"];
        NSInteger bandName = [self.database.arrayColumnNames indexOfObject:@"bandName"];
        NSInteger picture = [self.database.arrayColumnNames indexOfObject:@"pictureName"];
        NSInteger url = [self.database.arrayColumnNames indexOfObject:@"url"];

        if (self.searchController.active) {
            detailViewController.songTitle = [[self.searchResults objectAtIndex:indexPath.row] objectAtIndex:title];
            detailViewController.bandName = [[self.searchResults objectAtIndex:indexPath.row] objectAtIndex:bandName];
            detailViewController.imageName = [[self.searchResults objectAtIndex:indexPath.row] objectAtIndex:picture];
            detailViewController.songPath = [[self.searchResults objectAtIndex:indexPath.row] objectAtIndex:url];
        } else {
        detailViewController.songTitle = [[self.arraySonglistInfo objectAtIndex:indexPath.row] objectAtIndex:title];
        detailViewController.bandName = [[self.arraySonglistInfo objectAtIndex:indexPath.row] objectAtIndex:bandName];
        detailViewController.imageName = [[self.arraySonglistInfo objectAtIndex:indexPath.row] objectAtIndex:picture];
        detailViewController.songPath = [[self.arraySonglistInfo objectAtIndex:indexPath.row] objectAtIndex:url];
        }
    }
}

#pragma mark - Search


- (void) updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    //Search the titles of songs which contain the serch string.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF[1] CONTAINS[c] %@",searchString];
    //Initialize the search results
    if (self.searchResults != nil) {
        [self.searchResults removeAllObjects];
    }
    //Store the search results
    self.searchResults = [NSMutableArray arrayWithArray:[self.arraySonglistInfo filteredArrayUsingPredicate:predicate]];
    //Reload the table view and show the searched data.
    [self.tblSonglist reloadData];

    

}
@end
