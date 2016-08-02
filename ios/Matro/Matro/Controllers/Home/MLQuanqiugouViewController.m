//
//  MLQuanqiugouViewController.m
//  Matro
//
//  Created by Matro on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLQuanqiugouViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MLFristTableViewCell.h"
#import "MLFristCollectionViewCell.h"
#import "MLFirstHeaderView.h"
#import "MLSecondTableViewCell.h"
#import "MLThirdTableViewCell.h"
#import "MLAdTableViewCell.h"

@interface MLQuanqiugouViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{

    NSMutableArray *_imageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic)UIScrollView *imageScrollView;
@property (strong,nonatomic)UIPageControl *pagecontrol;
@end

@implementation MLQuanqiugouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.backgroundColor = RGBA(245, 245, 245, 1);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"MLFirstHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MLFirstHeaderView"];

    [self.view addSubview:self.tableview];
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 232)];
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 232)];
    _pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake((MAIN_SCREEN_WIDTH-240)/2, 212, 80, 20)];
    
    [headview addSubview:_imageScrollView];
    [headview addSubview: _pagecontrol];
    _tableview.tableHeaderView  = headview;
    
    _imageArray = [[NSMutableArray alloc]initWithObjects:@"http://img-test.matrostyle.com/uploadfile/webframe/160622_576a4224ee4dd.jpg_1125X696-50.jpg",
    @"http://img-test.matrostyle.com/uploadfile/webframe/160622_576a42075eeae.jpg_1125X696-50.jpg",
    @"http://img-test.matrostyle.com/uploadfile/webframe/160622_576a41ed8ef5a.jpg_1125X696-50.jpg",
                    nil];

    if (![_imageArray isKindOfClass:[NSNull class]]) {//防崩溃
        [self imageUIInit];
    }
    
}


#pragma mark tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 7;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"MLFristTableViewCell" ;
        MLFristTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }else if (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3){
        static NSString *CellIdentifier = @"MLAdTableViewCell" ;
        MLAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }else if (indexPath.section == 4){
        static NSString *CellIdentifier = @"MLSecondTableViewCell" ;
        MLAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;

    }else {
        
        static NSString *CellIdentifier = @"MLThirdTableViewCell" ;
        MLAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 288;
    }else if (indexPath.section == 4 || indexPath.section == 5){
    
        return 305;
    }

    return 150;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 4) {
        MLFirstHeaderView *FirstHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MLFirstHeaderView"];
        if (!FirstHeaderView) {
            FirstHeaderView = [[MLFirstHeaderView alloc]initWithReuseIdentifier:@"MLFirstHeaderView"];
        }
        
        return FirstHeaderView;
    }else if (section == 5){
  
        MLFirstHeaderView *FirstHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MLFirstHeaderView"];
        if (!FirstHeaderView) {
            FirstHeaderView = [[MLFirstHeaderView alloc]initWithReuseIdentifier:@"MLFirstHeaderView"];
        }
        
        return FirstHeaderView;
    }else{
 
        return nil;
    }
   
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section < 4) {
        return 0;
        
    }else{
        
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 5;
}


#pragma mark- 图片相关
- (void)imageUIInit {
    
    CGFloat imageScrollViewWidth = MAIN_SCREEN_WIDTH;
    CGFloat imageScrollViewHeight = _imageScrollView.bounds.size.height;
    
    for(int i = 0; i<_imageArray.count; i++) {
        if ([_imageArray[i] isKindOfClass:[NSNull class]]) {
            continue;
        }
    }
    for (int i=0; i<_imageArray.count; i++) {
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        NSLog(@"imageview == %@",imageview.sd_imageURL);
        
       // imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.tag = i;
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        [imageview addGestureRecognizer:singleTap];
        [_imageScrollView addSubview:imageview];
    }
    
    _imageScrollView.contentSize = CGSizeMake(imageScrollViewWidth*_imageArray.count, 0);
    _imageScrollView.bounces = NO;
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.delegate = self;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    
    _pagecontrol.numberOfPages = _imageArray.count;
    
    _pagecontrol.tintColor = [UIColor redColor];
    _pagecontrol.currentPageIndicatorTintColor = [UIColor yellowColor];
}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
    
    NSLog(@"%ld",tap.view.tag);
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _imageScrollView) {
        NSInteger i = scrollView.contentOffset.x/scrollView.frame.size.width + 1;
        _pagecontrol.currentPage = i - 1;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
