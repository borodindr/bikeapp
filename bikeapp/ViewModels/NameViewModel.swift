//
//  NameViewModel.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import Foundation
import RxSwift
import RxCocoa

class NameViewModel {
    
    let firstNameSubject = ReplaySubject<String>.create(bufferSize: 1)
    let lastNameSubject = ReplaySubject<String>.create(bufferSize: 1)
    
    var canGoNext: Observable<Bool> {
        Observable.combineLatest(firstNameSubject, lastNameSubject)
            .map { !$0.isEmpty && !$1.isEmpty }
    }
    
    func prepareForNext() -> Observable<Bool> {
        Observable.combineLatest(firstNameSubject, lastNameSubject)
            .take(1)
            .do(onNext: { firstName, lastName in
                ProfileManager.shared.createNew(firstName: firstName, lastName: lastName)
            })
            .map { _ in true }
    }
    
}
