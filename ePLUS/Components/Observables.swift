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
    @Published var dayIndex: Int = 0
}

class UserData: ObservableObject {
    @Published var currentUser: User = User(account: "guest", password: "guest", nickname: "guest", plans: [], comments: [])
}
