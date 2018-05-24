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
    ASTextNode *_textNode;

    NSArray *_imageArr;
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
    
    NSMutableArray *tempImageArr = [NSMutableArray array];
    for (NSUInteger i = 0 ; i < 5; i++) {
        ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc] init];
//        imageNode.backgroundColor = [UIColor blackColor];
//        imageNode.URL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526880861368&di=2ed63e32545cefc1349a946335b28959&imgtype=0&src=http%3A%2F%2Fp.yjbys.com%2Fimage%2F20161018%2F1476763524820960.jpg"];
        [imageNode setImage:[UIImage imageNamed:@"timg"]];
        [self addSubnode:imageNode];
        imageNode.layerBacked = YES;
        [tempImageArr addObject:imageNode];
    }
    _imageArr = tempImageArr;
}

- (void)didLoad {
    [super didLoad];
    for (ASNetworkImageNode *imageNode in _imageArr) {
        CALayer *maskL = [[CALayer alloc] init];
        maskL.frame = CGRectMake(0, 0, 40, 40);
        maskL.contents = (id) [UIImage imageNamed:@"head_background"].CGImage;
        imageNode.layer.mask = maskL;
        imageNode.layer.masksToBounds = YES;
        imageNode.layer.shouldRasterize = YES;
        imageNode.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
}

- (void)layout {
    [super layout];
    CGRect preFrame = CGRectZero;
    for (ASNetworkImageNode *imageNode in _imageArr) {
        imageNode.frame = CGRectMake(CGRectGetMaxX(preFrame), 0, 40, 40);
        preFrame = imageNode.frame;
    }

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
