//
//  MLCusHelpViewController.m
//  Matro
//
//  Created by MR.Huang on 16/5/7.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLCusHelpViewController.h"
#import "MLCusServiceCell.h"
#import "MLHelpCenterDetailController.h"

@interface MLCusHelpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleItems;
    NSArray *webCodes;
}
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation MLCusHelpViewController


- (instancetype)initWithHelpType:(HelpType)helpType{
    if (self = [super init]) {
        _helpType = helpType;
        switch (_helpType) {
            case GuidHelp://购物指南
            {
                titleItems = @[@"购物流程",@"配送政策",@"进度查询"];
                webCodes = @[@"0304010101",@"0304010102",@"0304010103"];
                
            }
                break;
            case EnsureHelp://服务保障
            {
                titleItems = @[@"100%正品保证",@"七天无忧放心退",@"一对一专属客服"];
                webCodes = @[@"0304010201",@"0304010202",@"0304010203"];
            }
                break;
            case PayHelp://支付帮助
            {
                titleItems = @[@"在线支付",@"支付遇到问题"];
                webCodes = @[@"0304010301",@"0304010302"];
            }
                break;
            case ServiceHelp://售后服务
            {
                titleItems = @[@"退货流程",@"退货政策",@"退款方式",@"跨境购须知"];
                webCodes = @[@"0304010401",@"0304010402",@"0304010403",@"0304010404"];
            }
                break;
            case ProblemHelp: //常见问题
            {
                titleItems = @[@"问题指南",@"通关关税",@"争议处理规范",@"完税价格表"];
            }
                break;
                
            default:
                break;
        }

    
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"帮助中心";
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"MLCusServiceCell" bundle:nil] forCellReuseIdentifier:kMLCusServiceCell];
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 180)];
        headImg.image = [UIImage imageNamed:@"img_bangzhuzhongxing"];
        tableView.tableHeaderView = headImg;
        [self.view addSubview:tableView];
        tableView;
    });
    
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MLCusServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLCusServiceCell forIndexPath:indexPath];
    cell.myImageView.hidden = YES;
    cell.myTitleLabel.text = [titleItems objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *webCode = [webCodes objectAtIndex:indexPath.row];
    
    MLHelpCenterDetailController *vc = [[MLHelpCenterDetailController alloc]init];
    vc.webCode = webCode;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
