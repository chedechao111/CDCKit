//
//  ASTestViewController.m
//  CDCKit
//
//  Created by 车德超 on 2018/5/18.
//  Copyright © 2018年 车德超. All rights reserved.
//

#import "ASTestViewController.h"

@interface CDCell : ASCellNode

@end

@implementation CDCell
{
    ASNetworkImageNode *_imageNode;
    ASTextNode *_textNode;
    CALayer *_maskL;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    ASTextNode *textNode = [[ASTextNode alloc] init];
    textNode.attributedText = [[NSAttributedString alloc] initWithString:@"dfgh"];
//    textNode.frame = CGRectMake(0, 0, 100, 10);
    [self addSubnode:textNode];
    _textNode = textNode;
    
    ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc] init];
    imageNode.URL = [NSURL URLWithString:@"http://img05.tooopen.com/images/20140328/sy_57865838889.jpg"];
//    imageNode.frame = CGRectMake(0, 0, 40, 40);
    NSLog(@"i'm cell. i'm in %@",[NSThread currentThread]);
    [self.view addSubnode:imageNode];
    CALayer *maskL = [[CALayer alloc] init];
    maskL.contents = (id) [UIImage imageNamed:@"head_background"].CGImage;
    _imageNode.layer.mask = maskL;
    _imageNode.layer.masksToBounds = YES;
    _maskL = maskL;
    _imageNode = imageNode;
}

- (void)didLoad {
    [super didLoad];
    NSLog(@"i'm didLoad. i'm in %@",[NSThread currentThread]);
//    CALayer *maskL = [[CALayer alloc] init];
//    maskL.contents = (id) [UIImage imageNamed:@"head_background"].CGImage;
//    _imageNode.layer.mask = maskL;
//    _imageNode.layer.masksToBounds = YES;
//    _maskL = maskL;
}

- (void)layout {
    [super layout];
    _maskL.frame = CGRectMake(0, 0, 40, 40);
    _imageNode.frame = CGRectMake(0, 0, 40, 40);
}

@end

@interface ASTestViewController () <ASTableDelegate, ASTableDataSource>

@end

@implementation ASTestViewController
{
    ASTableNode *_tableNode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.frame = self.view.bounds;
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    _tableNode.backgroundColor = [UIColor greenColor];
    [self.view addSubnode:_tableNode];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableNode.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^(){
        CDCell *c = [[CDCell alloc] init];
        return c;
    };
}

- (ASSizeRange)tableView:(ASTableNode *)tableNode constrainedSizeForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ASSizeRangeMake(CGSizeMake(self.view.width, 40));
}

@end
