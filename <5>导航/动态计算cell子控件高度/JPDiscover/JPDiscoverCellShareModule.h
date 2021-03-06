//
//  JPDiscoverCellShareModule.h
//  JPDiscover
//
//  Created by Jasper on 16/3/25.
//  Copyright © 2016年 Jasper. All rights reserved.
//

#import "JPDiscoverCellBaseModule.h"

@interface JPDiscoverCellShareModule : JPDiscoverCellBaseModule

@property (nonatomic, copy) JPDiscoverTapBlock tapBlock;

- (id)initWithWidth:(CGFloat)widthTemp;

- (void)setDataWithModel:(JPDiscoverShareModel *)model;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com