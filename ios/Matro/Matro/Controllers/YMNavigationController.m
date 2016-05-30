//
//  YMNavigationController.m
//  YMShare
//
//  Created by MR.Huang on 16/1/4.
//  Copyright © 2016年 YMKJ. All rights reserved.
//

#import "YMNavigationController.h"
#import "HFSConstants.h"


@interface YMNavigationController ()

@end

@implementation YMNavigationController
@synthesize alphaView;


-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        CGRect frame = self.navigationBar.frame;
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        alphaView.backgroundColor = RGBA(255, 255, 255,1);
        
        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"none.png"] forBarMetrics:UIBarMetricsCompact];
        self.navigationBar.layer.masksToBounds = YES;
        [self.navigationBar
         setTitleTextAttributes:
         @{NSFontAttributeName: [UIFont systemFontOfSize:16],
           NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.navigationBar.tintColor = [UIColor blackColor];

        
    }
    return self;
}



-(void)setAlph{
    if (_changing == NO) {
        _changing = YES;
        if (alphaView.alpha == 0.0 ) {
            [UIView animateWithDuration:0.5 animations:^{
                alphaView.alpha = 1.0;
            } completion:^(BOOL finished) {
                _changing = NO;
            }];
        }else{
            alphaView.alpha = 0.0;
            _changing = NO;
        }
    }
}

- (void)showNavBar{
    [UIView animateWithDuration:0.3 animations:^{
        alphaView.alpha = 1.0;
    }];
    
}

- (void)hiddenNavBar{
    alphaView.alpha = 0;

}



@end
