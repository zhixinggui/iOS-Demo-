//
//  RxTableViewReactiveArrayDataSource.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 6/26/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)

import Foundation
import UIKit
#if !RX_NO_MODULE
import RxSwift
#endif

// objc monkey business
class _RxTableViewReactiveArrayDataSource
    : NSObject
    , UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
   
    func _tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tableView(tableView, numberOfRowsInSection: section)
    }

    func _tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        rxAbstractMethod()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return _tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
}


class RxTableViewReactiveArrayDataSourceSequenceWrapper<S: SequenceType>
    : RxTableViewReactiveArrayDataSource<S.Generator.Element>
    , RxTableViewDataSourceType {
    typealias Element = S

    override init(cellFactory: CellFactory) {
        super.init(cellFactory: cellFactory)
    }

    func tableView(tableView: UITableView, observedEvent: Event<S>) {
        switch observedEvent {
        case .Next(let value):
            super.tableView(tableView, observedElements: Array(value))
        case .Error(let error):
            bindingErrorToInterface(error)
        case .Completed:
            break
        }
    }
}

// Please take a look at `DelegateProxyType.swift`
class RxTableViewReactiveArrayDataSource<Element>
    : _RxTableViewReactiveArrayDataSource
    , SectionedViewDataSourceType {
    typealias CellFactory = (UITableView, Int, Element) -> UITableViewCell
    
    var itemModels: [Element]? = nil
    
    func modelAtIndex(index: Int) -> Element? {
        return itemModels?[index]
    }

    func modelAtIndexPath(indexPath: NSIndexPath) throws -> Any {
        precondition(indexPath.section == 0)
        guard let item = itemModels?[indexPath.item] else {
            throw RxCocoaError.ItemsNotYetBound(object: self)
        }
        return item
    }

    let cellFactory: CellFactory
    
    init(cellFactory: CellFactory) {
        self.cellFactory = cellFactory
    }
    
    override func _tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModels?.count ?? 0
    }
    
    override func _tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellFactory(tableView, indexPath.item, itemModels![indexPath.row])
    }
    
    // reactive
    
    func tableView(tableView: UITableView, observedElements: [Element]) {
        self.itemModels = observedElements
        
        tableView.reloadData()
    }
}

#endif
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com