
//
//  MLOrderSubHeadView.m
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderSubHeadView.h"
#import "HFSConstants.h"
#import "MLHttpManager.h"
#import "HFSConstants.h"
#import "NSString+URLZL.h"

@interface MLOrderSubHeadView ()
@property (nonatomic,assign)BOOL isFirst;

@end

@implementation MLOrderSubHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.cornerRadius = 3.f;
    self.editBtn.layer.borderWidth = 1.f;
    self.editBtn.layer.borderColor = RGBA(174, 142, 93, 1).CGColor;
}



+ (MLOrderSubHeadView *)headView{
    return LoadNibWithSelfClassName;
}

- (IBAction)saveClick:(id)sender {
    if (!_isFirst) { //第一次点击保存时
        self.sfLeading.constant = 16;
        self.fieldLeading.constant = 0;
        _isFirst = YES;
        [self saveShenFenzheng];
    }else{
        if ([self.editBtn.titleLabel.text isEqualToString:@"编辑"]) {//如果是编辑状态
            self.shenfenzhengField.userInteractionEnabled = YES;
            [self.editBtn setTitle:@"保存" forState:UIControlStateNormal];
            
        }else{//如果是保存
            [self saveShenFenzheng];
            
        }
    }
    
}


- (void)haveIdCardSave{
    self.sfLeading.constant = 16;
    self.fieldLeading.constant = 0;
    _isFirst = YES;
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.shenfenzhengField.userInteractionEnabled = NO;
    _isFirst = YES;
}



- (void)saveShenFenzheng{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_member&action=edit_identity_card&accessToken=%@",MATROJP_BASE_URL,[token URLEncodedString]];
    NSDictionary *params = @{@"identity_card":self.shenfenzhengField.text,@"mobile":self.phoneLabel.text};
    [MLHttpManager post:url params:params m:@"member" s:@"admin_member" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] isEqual:@0]) {
             self.shenfenzhengField.userInteractionEnabled = NO;
            [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            if (self.idcardisOk) {
                self.idcardisOk(YES);
            }
        }
        else{
            NSString *msg = result[@"msg"];
            if (self.orderSubChangeInfo) {
                self.orderSubChangeInfo(msg);
            }
            if (self.idcardisOk) {
                self.idcardisOk(NO);
            }
        }
    } failure:^(NSError *error) {
    }];
}






@end