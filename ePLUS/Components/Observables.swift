//
//  Observables.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/30.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .list
}

class DayRouter: ObservableObject {
    var dayIndex: Int = 0 {
        willSet {
            objectWillChange.send()
        }
    }
}
