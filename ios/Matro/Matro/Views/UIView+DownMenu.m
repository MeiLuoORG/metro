//
//  UIView+DownMenu.m
//  Menu
//
//  Created by 黄裕华 on 16/7/1.
//  Copyright © 2016年 hyh. All rights reserved.
//

#import "UIView+DownMenu.h"
#import <objc/runtime.h>
#import "Masonry.h"

@implementation UIView (DownMenu)
static char bgViewKey;

- (void)setDownMenu:(DownMenuBgView *)downMenu{
    [self willChangeValueForKey:@"bgViewKey"];
    objc_setAssociatedObject(self, &bgViewKey, downMenu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"bgViewKey"];
}

- (DownMenuBgView *)downMenu{
    return objc_getAssociatedObject(self, &bgViewKey);
}

- (void)showDownMenuWithItems:(NSArray *)items AndSelBlock:(DidSelectAtIndex)selIndex{
    if (self.downMenu == nil) {
        self.downMenu = [[DownMenuBgView alloc]initWithFrame:self.bounds];
        self.downMenu.didSelBlock = selIndex;
        self.downMenu.items = items;
        self.downMenu.backgroundColor = [UIColor clearColor];
    }
    [self addSubview:self.downMenu];
    
   
}


@end

@interface DownMenuBgView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIImageView *bkImageView;

@end

@implementation DownMenuBgView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        bgImage.image = [UIImage imageNamed:@"juxingzl"];
        bgImage.contentMode = UIViewContentModeScaleToFill;
        bgImage.userInteractionEnabled = YES;
        self.bkImageView = bgImage;
        
        [self addSubview:bgImage];
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.right.mas_equalTo(self).offset(-16);
            make.height.mas_equalTo(35*4+14);
            make.width.mas_equalTo(160);
        }];
        self.tableView = ({
            UITableView *tableView =[[UITableView alloc]initWithFrame:CGRectZero];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.bounces = NO;
            tableView.scrollEnabled = NO;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerNib:[UINib nibWithNibName:@"DownMenuCell" bundle:nil] forCellReuseIdentifier:kDownMenuCell];
            [bgImage addSubview:tableView];
            tableView;
        });
        
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgImage).offset(10);
            make.left.equalTo(bgImage).offset(2);
            make.right.equalTo(bgImage).offset(-2);
            make.bottom.equalTo(bgImage).offset(-2);
        }];
        [self addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
//    [[UIColor
//      blueColor] setStroke]; //设置边框颜色
//    CGContextBeginPath(context);//标记
//    CGFloat startX = CGRectGetMaxX(self.tableView.frame) - 20;
//    CGFloat maxX = startX + 5;
//    CGFloat minX = startX - 5;
//    CGFloat startY = CGRectGetMinY(self.tableView.frame) - 5;
//    CGFloat endY = CGRectGetMinY(self.tableView.frame);
//    CGContextMoveToPoint(context,
//                         startX, startY);//设置起点
//    CGContextAddLineToPoint(context,
//                            maxX, endY);
//    CGContextAddLineToPoint(context,
//                            minX, endY);
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//    CGContextFillPath(context);
//}

- (void)closeWindow{
    [self removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:kDownMenuCell forIndexPath:indexPath];
    NSDictionary *dic = [self.items objectAtIndex:indexPath.row];
    cell.titleLabel.text = dic[@"title"];
    cell.myImageView.image = [UIImage imageNamed:dic[@"img"]];
    cell.line.hidden = (indexPath.row == self.items.count-1);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelBlock) {
        self.didSelBlock(indexPath.row);
    }
    [self removeFromSuperview];
}


- (void)setItems:(NSArray *)items{
    if (_items != items) {
        _items = items;
        [self.bkImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.right.mas_equalTo(self).offset(-16);
            make.height.mas_equalTo(35*_items.count+14);
            make.width.mas_equalTo(160);
        }];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bkImageView).offset(10);
            make.left.equalTo(self.bkImageView).offset(2);
            make.right.equalTo(self.bkImageView).offset(-2);
            make.bottom.equalTo(self.bkImageView).offset(-2);
        }];
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

@end

@implementation DownMenuCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end














