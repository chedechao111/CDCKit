//
//  CDTableViewController.m
//  CDCKit
//
//  Created by 车德超 on 2018/4/8.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "CDTableViewController.h"
#import "CDDynamicViewController.h"
#import "CDCircleFromController.h"
#import "CDPageFromVC.h"

static NSString *const cellID = @"cellID";

@interface CDTableViewController ()

@end

@implementation CDTableViewController
{
    NSArray *_cellNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor grayColor];
    _cellNames = @[@"Present",@"1",@"1",@"1",@"1"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.tableView.estimatedRowHeight = 0;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    UILabel *label = [self name:_cellNames[indexPath.row]];
    label.frame = CGRectMake(20, 20, label.frame.size.width, label.frame.size.height);
    [cell addSubview:label];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CDPageFromVC *pageVC =[CDPageFromVC new];
    [self.navigationController pushViewController:pageVC animated:YES];
}

- (UILabel *)name:(NSString *)name {
    UILabel *label = [UILabel new];
    label.text = name;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}

@end
