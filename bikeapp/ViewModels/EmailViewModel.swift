//
//  EmailViewModel.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 21.09.2020.
//

import Foundation
import RxSwift
import RxCocoa

class EmailViewModel {
    
    let emailSubject = ReplaySubject<String>.create(bufferSize: 1)
    
    var canGoNext: Observable<Bool> {
        emailSubject
            .map { $0.isEmail }
    }
    
    func prepareForNext() -> Observable<Bool> {
        emailSubject.take(1)
            .do(onNext: { email in
                try ProfileManager.shared.add(email: email)
            })
            .map { _ in true }
    }
    
}
