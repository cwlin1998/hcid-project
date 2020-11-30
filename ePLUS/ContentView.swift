//
//  ContentView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/25.
//

import SwiftUI

enum Page {
    case list
    case map
}

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
        case .list:
            ListView()
        case .map:
            MapView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
