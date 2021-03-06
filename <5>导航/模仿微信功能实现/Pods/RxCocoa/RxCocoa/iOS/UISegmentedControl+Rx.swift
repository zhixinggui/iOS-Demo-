//
//  UISegmentedControl+Rx.swift
//  RxCocoa
//
//  Created by Carlos García on 8/7/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
#if !RX_NO_MODULE
import RxSwift
#endif


extension UISegmentedControl {
    
    /**
    Reactive wrapper for `selectedSegmentIndex` property.
    */
    public var rx_value: ControlProperty<Int> {
        return rx_value(getter: { [weak self] in
            self?.selectedSegmentIndex ?? 0
        }, setter: { [weak self] value in
            self?.selectedSegmentIndex = value
        })
    }
    
}

#endif
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com