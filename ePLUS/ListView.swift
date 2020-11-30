//
//  ListView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/30.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack(content: {
            Text("This is the list page.")
            Button(action: {
                viewRouter.currentPage = .map
            }, label: {
                Text("Show in map")
            })
        })
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environmentObject(ViewRouter())
    }
}
