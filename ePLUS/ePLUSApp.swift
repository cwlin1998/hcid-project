//
//  ePLUSApp.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/25.
//

import SwiftUI

@main
struct ePLUSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewRouter)
        }
    }
}
