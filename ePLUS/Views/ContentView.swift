//
//  ContentView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/25.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var dayRouter: DayRouter
    @EnvironmentObject var userData: UserData
        
    var body: some View {
        VStack {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewRouter())
            .environmentObject(DayRouter())
            .environmentObject(UserData())
    }
}
