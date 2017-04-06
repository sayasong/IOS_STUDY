//
//  MRMapViewController.m
//  MAO_STUDY
//
//  Created by 毛睿 on 2017/4/6.
//  Copyright © 2017年 AKeyChat. All rights reserved.
//

#import "MRMapViewController.h"
#import "MRMapEngine.h"
@interface MRMapViewController ()

@end

@implementation MRMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    /*面向协议编程*/
    MRMapEngine *mapEngine = [[MRMapEngine alloc] init];
    id<MRMapFactoryProtocol> factory = [mapEngine getFactory];
    id<MRMapProtocol> mapView = [factory getMapView:self.view.frame];
    [self.view addSubview:[mapView getView]];
}

@end
