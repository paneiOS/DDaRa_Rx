//
//  ViewModel.swift
//  DDaRa
//
//  Created by 이정환 on 2022/12/29.
//

import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
