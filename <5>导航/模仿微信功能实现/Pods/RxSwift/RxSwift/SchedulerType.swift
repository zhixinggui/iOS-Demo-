//
//  SchedulerType.swift
//  Rx
//
//  Created by Krunoslav Zaher on 2/8/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

/**
Type that represents time interval in the context of RxSwift.
*/
public typealias RxTimeInterval = NSTimeInterval

/**
Type that represents absolute time in the context of RxSwift.
*/
public typealias RxTime = NSDate

/**
Represents an object that schedules units of work.
*/
public protocol SchedulerType: ImmediateSchedulerType {

    /**
    - returns: Current time.
    */
    var now : RxTime {
        get
    }

    /**
    Schedules an action to be executed.
    
    - parameter state: State passed to the action to be executed.
    - parameter dueTime: Relative time after which to execute the action.
    - parameter action: Action to be executed.
    - returns: The disposable object used to cancel the scheduled action (best effort).
    */
    func scheduleRelative<StateType>(state: StateType, dueTime: RxTimeInterval, action: (StateType) -> Disposable) -> Disposable
 
    /**
    Schedules a periodic piece of work.
    
    - parameter state: State passed to the action to be executed.
    - parameter startAfter: Period after which initial work should be run.
    - parameter period: Period for running the work periodically.
    - parameter action: Action to be executed.
    - returns: The disposable object used to cancel the scheduled action (best effort).
    */
    func schedulePeriodic<StateType>(state: StateType, startAfter: RxTimeInterval, period: RxTimeInterval, action: (StateType) -> StateType) -> Disposable
}

extension SchedulerType {

    /**
    Periodic task will be emulated using recursive scheduling.

    - parameter state: Initial state passed to the action upon the first iteration.
    - parameter startAfter: Period after which initial work should be run.
    - parameter period: Period for running the work periodically.
    - returns: The disposable object used to cancel the scheduled recurring action (best effort).
    */
    public func schedulePeriodic<StateType>(state: StateType, startAfter: RxTimeInterval, period: RxTimeInterval, action: (StateType) -> StateType) -> Disposable {
        let schedule = SchedulePeriodicRecursive(scheduler: self, startAfter: startAfter, period: period, action: action, state: state)
            
        return schedule.start()
    }

    func scheduleRecursive<State>(state: State, dueTime: RxTimeInterval, action: (state: State, scheduler: AnyRecursiveScheduler<State>) -> ()) -> Disposable {
        let scheduler = AnyRecursiveScheduler(scheduler: self, action: action)
         
        scheduler.schedule(state, dueTime: dueTime)
            
        return AnonymousDisposable {
            scheduler.dispose()
        }
    }
}// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com