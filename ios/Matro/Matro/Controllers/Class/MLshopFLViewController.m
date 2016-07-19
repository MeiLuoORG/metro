//
//  MLshopFLViewController.m
//  Matro
//
//  Created by Matro on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLshopFLViewController.h"
#import <RATreeView/RATreeView.h>
#import "RADataObject.h"
#import "HFSServiceClient.h"
#import "UIColor+HeinQi.h"
#import "UIViewController+MLMenu.h"
#import "MLshopGoodsListViewController.h"
#import "CommonHeader.h"
#import "MLHttpManager.h"
@interface MLshopFLViewController ()<RATreeViewDelegate,RATreeViewDataSource>{
    
    RADataObject *_selectedItem;
    RADataObject *secondName;
    
    NSMutableArray *spArray;
    NSMutableArray *secondArray;
    
    NSMutableDictionary *paramfilterDic;
}
@property (weak, nonatomic) IBOutlet RATreeView *treeView;

@end

@implementation MLshopFLViewController
@synthesize uid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品分类";
    _treeView.delegate = self;
    _treeView.dataSource = self;
    _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [_treeView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TypeCellIdentifier"];
    spArray = [NSMutableArray array];
    secondArray = [NSMutableArray array];
    [self addMenuButton];
    [self loadretCat];
}


//分类
-(void)loadretCat{
    //（分类）

    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=filter&key=&brandid=&searchType=1&userid=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,uid,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"product" s:@"filter" success:^(id responseObject){
        NSLog(@"responseObject ====%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *result = dataDic[@"retcat"];
        
        NSLog(@"result=222=%@",result);
        
        if (result && result.count > 0) {
            int i=0;
            for (NSDictionary *temp in result) {
                NSDictionary *toptemp = temp[@"top"];
                NSArray *secondArr = temp[@"second"];
                
                RADataObject *itemAll = [RADataObject dataObjectWithIdstr:toptemp[@"catid"] name:toptemp[@"cat"] children:nil];
                
                for (NSDictionary *secondDic in secondArr) {
                    
                    secondName = [RADataObject dataObjectWithIdstr:secondDic[@"catid"] name:secondDic[@"cat"] children:nil];
                    [itemAll addChild:secondName];
                }
                
                itemAll.level = @0;
                itemAll.dataId = [NSNumber numberWithInt:0];
                itemAll.selected = NO;
                [spArray addObject:itemAll];
                
                i++;
                
            }
            [_treeView reloadData];
        }
        
        NSLog(@"请求成功");
        
    } failure:^(NSError *error){
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"请求失败";
        [_hud hide:YES afterDelay:1];
        
    }];
    /*
    [[HFSServiceClient sharedJSONClient] GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject ====%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        
        NSArray *result = dataDic[@"retcat"];
        
        NSLog(@"result=222=%@",result);
        
        if (result && result.count > 0) {
            int i=0;
            for (NSDictionary *temp in result) {
                NSDictionary *toptemp = temp[@"top"];
                NSArray *secondArr = temp[@"second"];
                
                RADataObject *itemAll = [RADataObject dataObjectWithIdstr:toptemp[@"catid"] name:toptemp[@"cat"] children:nil];
                
                for (NSDictionary *secondDic in secondArr) {
                    
                    secondName = [RADataObject dataObjectWithIdstr:secondDic[@"catid"] name:secondDic[@"cat"] children:nil];
                    [itemAll addChild:secondName];
                }
                
                itemAll.level = @0;
                itemAll.dataId = [NSNumber numberWithInt:0];
                itemAll.selected = NO;
                [spArray addObject:itemAll];
                
                i++;
                
            }
            [_treeView reloadData];
        }
        
        NSLog(@"请求成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    */
}

#pragma mark- 分类
#pragma mark- RATreeViewDataSource

-(UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    static NSString *cellIdentifier = @"TypeCellIdentifier";
    UITableViewCell *cell = [_treeView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    RADataObject *data = item;
    
    if (data.children.count > 0) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Left_Arrow_yuan2"]];
        cell.tintColor = [UIColor colorWithHexString:@"#260E00"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#260E00"];
    } else {
        
        if (data.selected) {
            cell.tintColor = [UIColor colorWithHexString:@"#260E00"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#260E00"];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
        } else {
            cell.tintColor = [UIColor colorWithHexString:@"#260E00"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#260E00"];
            cell.accessoryView = nil;
        }
    }
    
    cell.textLabel.text = data.name;
    
    return cell;
}

-(NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (item) {
        RADataObject *data = item;
        return data.children.count;
    }
    return spArray.count;
    
}

-(id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    
    RADataObject *data = item;
    if (data) {
        return data.children[index];
    }
    return spArray[index];
}

#pragma mark- RATreeViewDelegate

-(void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    RADataObject *data = item;
    if (data.children.count > 0) {
        UITableViewCell *cell = [treeView cellForItem:item];
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shangjian"]];
    }
}

-(void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    RADataObject *data = item;
    
    if (data.children.count > 0) {
        UITableViewCell *cell = [treeView cellForItem:item];
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Left_Arrow_yuan2"]];
    }
}

-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    
        if (item == _selectedItem) {
            
            RADataObject *data = item;
            
            UITableViewCell *cell = [treeView cellForItem:item];
            
            if (data.children.count == 0) {
                if (!data.selected) {
                    
                    cell.tintColor = [UIColor colorWithHexString:@"#260E00"];
                    cell.textLabel.textColor = [UIColor colorWithHexString:@"#260E00"];
                    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
                    data.selected = YES;
                }
            }
        } else {
            
            RADataObject *data = item;
            if (data.children.count == 0 ) {
                
                UITableViewCell *selectedCell = [treeView cellForItem:_selectedItem];
                selectedCell.tintColor = [UIColor colorWithHexString:@"#260E00"];
                selectedCell.textLabel.textColor = [UIColor colorWithHexString:@"#260E00"];
                selectedCell.accessoryView = nil;
                _selectedItem.selected = NO;
                
                UITableViewCell *cell = [treeView cellForItem:item];
                cell.tintColor = [UIColor colorWithHexString:@"#260E00"];
                cell.textLabel.textColor = [UIColor colorWithHexString:@"#260E00"];
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choice_icon"]];
                data.selected = YES;
                
                if (data) {
                    NSString *name = data.name;
                    NSString *spflcode = data.idstr;
                    
                    NSLog(@"%@==%@",name,spflcode);
                    MLshopGoodsListViewController *vc = [[MLshopGoodsListViewController alloc]init];
                    vc.filterParam =@{@"keyword":name,@"id":spflcode};
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    if (data.dataId.intValue==0) {//商品分类
                        [paramfilterDic setObject:[NSString stringWithFormat:@"%@",spflcode] forKey:@"id"];
                        
                    }
                }
                
                _selectedItem = item;
   
            }
        }

}

-(NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item {
    RADataObject *data = item;
    if (data) {
        if ([data.level isEqualToNumber:@0]) {
            return 0;
        } else {
            return 3;
        }
    }
    return 0;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
