//
//  Observable.swift
//  HelloFintech
//
//  Created by 雲端開發部-廖彥勛 on 2024/7/22.
//

import Foundation

class Observable<T> {

    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }

    private var listener: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
