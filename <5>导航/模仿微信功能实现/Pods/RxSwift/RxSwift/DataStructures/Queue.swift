//
//  Queue.swift
//  Rx
//
//  Created by Krunoslav Zaher on 3/21/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

/**
Data structure that represents queue.

Complexity of `enqueue`, `dequeue` is O(1) when number of operations is
averaged over N operations.

Complexity of `peek` is O(1).
*/
public struct Queue<T>: SequenceType {
    /**
    Type of generator.
    */
    public typealias Generator = AnyGenerator<T>
    
    private let _resizeFactor = 2
    
    private var _storage: ContiguousArray<T?>
    private var _count: Int
    private var _pushNextIndex: Int
    private var _initialCapacity: Int
    
    /**
    Creates new queue.
    
    - parameter capacity: Capacity of newly created queue.
    */
    public init(capacity: Int) {
        _initialCapacity = capacity
        
        _count = 0
        _pushNextIndex = 0
     
        if capacity > 0 {
            _storage = ContiguousArray<T?>(count: capacity, repeatedValue: nil)
        }
        else {
            _storage = ContiguousArray<T?>()
        }
    }
    
    private var dequeueIndex: Int {
        get {
           let index = _pushNextIndex - count
            return index < 0 ? index + _storage.count : index
        }
    }
    
    /**
    - returns: Is queue empty.
    */
    public var isEmpty: Bool {
        get {
            return count == 0
        }
    }
    
    /**
    - returns: Number of elements inside queue.
    */
    public var count: Int {
        get {
            return _count
        }
    }
    
    /**
    - returns: Element in front of a list of elements to `dequeue`.
    */
    public func peek() -> T {
        precondition(count > 0)
        
        return _storage[dequeueIndex]!
    }
    
    mutating private func resizeTo(size: Int) {
        var newStorage = ContiguousArray<T?>(count: size, repeatedValue: nil)
        
        let count = _count
        
        let dequeueIndex = self.dequeueIndex
        let spaceToEndOfQueue = _storage.count - dequeueIndex
        
        // first batch is from dequeue index to end of array
        let countElementsInFirstBatch = min(count, spaceToEndOfQueue)
        // second batch is wrapped from start of array to end of queue
        let numberOfElementsInSecondBatch = count - countElementsInFirstBatch
        
        newStorage[0 ..< countElementsInFirstBatch] = _storage[dequeueIndex ..< (dequeueIndex + countElementsInFirstBatch)]
        newStorage[countElementsInFirstBatch ..< (countElementsInFirstBatch + numberOfElementsInSecondBatch)] = _storage[0 ..< numberOfElementsInSecondBatch]
        
        _count = count
        _pushNextIndex = count
        _storage = newStorage
    }
    
    /**
    Enqueues `element`.
    
    - parameter element: Element to enqueue.
    */
    public mutating func enqueue(element: T) {
        if count == _storage.count {
            resizeTo(max(_storage.count, 1) * _resizeFactor)
        }
        
        _storage[_pushNextIndex] = element
        _pushNextIndex += 1
        _count = _count + 1
        
        if _pushNextIndex >= _storage.count {
            _pushNextIndex -= _storage.count
        }
    }
    
    private mutating func dequeueElementOnly() -> T {
        precondition(count > 0)
        
        let index = dequeueIndex
        let value = _storage[index]!
        
        _storage[index] = nil
        
        _count = _count - 1
        
        return value
    }

    /**
    Dequeues element or throws an exception in case queue is empty.
    
    - returns: Dequeued element.
    */
    public mutating func dequeue() -> T? {
        if self.count == 0 {
            return nil
        }

        let value = dequeueElementOnly()
        
        let downsizeLimit = _storage.count / (_resizeFactor * _resizeFactor)
        if _count < downsizeLimit && downsizeLimit >= _initialCapacity {
            resizeTo(_storage.count / _resizeFactor)
        }
        
        return value
    }
    
    /**
    - returns: Generator of contained elements.
    */
    public func generate() -> Generator {
        var i = dequeueIndex
        var count = _count

        return anyGenerator {
            if count == 0 {
                return nil
            }

            count -= 1
            if i >= self._storage.count {
                i -= self._storage.count
            }

            let element = self._storage[i]
            i += 1
            return element
        }
    }
}
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com