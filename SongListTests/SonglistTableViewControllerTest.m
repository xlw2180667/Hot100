//
//  SonglistTableViewControllerTest.m
//  SongList
//
//  Created by 谢 砾威 on 20/04/16.
//  Copyright © 2016 谢 砾威. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SonglistTableViewController.h"

@interface SonglistTableViewControllerTest : XCTestCase

@property (nonatomic) SonglistTableViewController *vcToTest;

@end

@implementation SonglistTableViewControllerTest

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vcToTest = [storyboard instantiateViewControllerWithIdentifier:@"songlistTableView"];
    [self.vcToTest performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.vcToTest = nil;
    [super tearDown];
}

#pragma mark - View loading tests
- (void) testTheViewLoads {
    XCTAssertNotNil(self.vcToTest.view,@"View not initiated properly");
}

- (void) testParentViewHasTableViewSubview {
    NSArray *subviews = self.vcToTest.view.subviews;
    XCTAssertTrue([subviews containsObject:self.vcToTest.tableView],@"View does not have a table subview");
}

- (void) testTableViewLoads {
    XCTAssertNotNil(self.vcToTest.tableView, @"Table View not initiated");
}

#pragma mark - UITableView tests

- (void) testTheTableViewHasDataSource {
    XCTAssertNotNil(self.vcToTest.tableView.dataSource,@"Table data source cannot be nil");
}

- (void) testTheTableViewConnectedToDelegate {
    XCTAssertNotNil(self.vcToTest.tableView.delegate, @"Table delegate cannot be nil");
}

- (void) testTableViewNumberOfRowsInSection {
    NSInteger expectedRows = 100;
    XCTAssertTrue([self.vcToTest tableView:self.vcToTest.tableView numberOfRowsInSection:0] == expectedRows,@"Table has %ld rows but it should have %ld",(long)[self.vcToTest tableView:self.vcToTest.tableView numberOfRowsInSection:0],(long)expectedRows);
}

- (void) testTableViewHeightForRowAtIndexPath {
    CGFloat expectedHeight = 80.0;
    CGFloat actualHeight = self.vcToTest.tableView.rowHeight;
    XCTAssertEqual(expectedHeight, actualHeight,@"Cell should have %f height, but they have %f",expectedHeight, actualHeight);
}

@end
