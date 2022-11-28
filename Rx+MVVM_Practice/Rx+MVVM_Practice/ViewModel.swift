//
//  ViewModel.swift
//  Rx+MVVM_Practice
//
//  Created by Jihee hwang on 2022/11/28.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewModelProtocol {
    var tap: PublishRelay<Void> { get }
    var number: Driver<String> { get }
}

final class ViewModel: ViewModelProtocol {
    // input
    let tap = PublishRelay<Void>()
    
    // output
    let number: Driver<String>
    
    let disposeBag = DisposeBag()
    private let model = BehaviorRelay<Model>(value: .init(number: 100))
    
    init(){
        self.number = self.model
            .map { "\($0.number)" }
            .asDriver(onErrorRecover: { _ in .empty() })
        
        self.tap
             .withLatestFrom(model)
             .map { model -> Model in
               var nextModel = model
               nextModel.number += 1
               return nextModel
             }.bind(to: self.model)
             .disposed(by: disposeBag)
         }
}
