//
//  LogInViewModel.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import Foundation
import RxSwift
import RxCocoa

class LogInViewModel {
    
    let emailSubject = ReplaySubject<String>.create(bufferSize: 1)
    let passwordSubject = ReplaySubject<String>.create(bufferSize: 1)
    
    var canGoNext: Observable<Bool> {
        Observable.combineLatest(emailSubject, passwordSubject)
            .map { $0.isEmail && $1.isPassword }
    }
    
    func prepareForNext() -> Observable<Bool> {
        Observable.combineLatest(emailSubject, passwordSubject)
            .take(1)
            .do(onNext: { email, password in
                try ProfileManager.shared.authenticate(email: email, password: password)
            })
            .map { _ in true }
    }
    
}
