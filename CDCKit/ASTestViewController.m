//
//  ASTestViewController.m
//  CDCKit
//
//  Created by 车德超 on 2018/5/18.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "ASTestViewController.h"

@interface ASTestViewController () <ASTableDelegate, ASTableDataSource>

@end

@implementation ASTestViewController
{
    ASTableNode *_tableNode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    _tableNode.backgroundColor = [UIColor greenColor];
    [self.view addSubnode:_tableNode];
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASCellNode *cell = [[ASCellNode alloc] init];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


@end
