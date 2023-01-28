//
//  SecondTimer.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/25.
//

import Foundation

protocol SecondTimer {
    var timerState: TimerState { get }
    
    func start(durationSeconds: Double,
               repeatingExecution: (() -> Void)?,
               completion: (() -> Void)?)
    func resume()
    func suspend()
    func cancel()
}

enum TimerState {
    case suspended
    case resumed
    case canceled
    case finished
}
