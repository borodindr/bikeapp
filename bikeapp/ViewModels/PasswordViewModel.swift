//
//  PasswordViewModel.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel {
    
    let passwordSubject = ReplaySubject<String>.create(bufferSize: 1)
    
    var canGoNext: Observable<Bool> {
        passwordSubject
            .map { $0.isPassword }
    }
    
    func prepareForNext() -> Observable<Bool> {
        passwordSubject.take(1)
            .do(onNext: { password in
                try ProfileManager.shared.add(password: password)
                try ProfileManager.shared.save()
            })
            .map { _ in true }
    }
    
}
