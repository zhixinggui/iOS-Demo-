//
//  NSTextStorage+Rx.swift
//  Rx
//
//  Created by Segii Shulga on 12/30/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)
import Foundation

#if !RX_NO_MODULE
    import RxSwift
#endif
    import UIKit

extension NSTextStorage {

    /**
     Reactive wrapper for `delegate`.

     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var rx_delegate:DelegateProxy {
        return proxyForObject(RxTextStorageDelegateProxy.self, self)
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var rx_didProcessEditingRangeChangeInLength: Observable<(editedMask:NSTextStorageEditActions, editedRange:NSRange, delta:Int)> {
        return rx_delegate
            .observe("textStorage:didProcessEditing:range:changeInLength:")
            .map { a in
                let editedMask = NSTextStorageEditActions(rawValue: try castOrThrow(UInt.self, a[1]) )
                let editedRange = try castOrThrow(NSValue.self, a[2]).rangeValue
                let delta = try castOrThrow(Int.self, a[3])
                
                return (editedMask, editedRange, delta)
            }
    }
}
#endif
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com