    
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
#import "Masonry.h"

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
    if (self.shenfenzhengField.text.length > 0) { //
        
    }
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

- (void)setIsShowSFZ:(BOOL)isShowSFZ{
        _isShowSFZ  = isShowSFZ;
        if (!_isShowSFZ) {
            [self.addressBgView removeFromSuperview];
            [self.addressControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.bottom.equalTo(self).offset(-8);
            }];
        }
}


- (void)setIsShowWarning:(BOOL)isShowWarning{
    _isShowWarning = isShowWarning;
    if (_isShowWarning) {
        self.warningLabel.hidden = NO;
        self.mapImage.hidden = NO;
        self.viewHeight.constant = 54;
        self.phoneImage.hidden = YES;
        self.nameImage.hidden = YES;
        self.nameLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.addressLabel.hidden = YES;
    }else{
        self.warningLabel.hidden = YES;
        self.mapImage.hidden = YES;
        self.viewHeight.constant = 90;
        self.phoneImage.hidden = NO;
        self.nameImage.hidden = NO;
        self.nameLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
        self.addressLabel.hidden = NO;
    }
}




@end
