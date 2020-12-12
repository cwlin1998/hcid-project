//
//  MapView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/30.
//

//import SwiftUI
//
//struct MapView: View {
//
//    @EnvironmentObject var viewRouter: ViewRouter
//
//    var body: some View {
//        VStack(content: {
//            Text("This is the map page.")
//            Button(action: {
//                viewRouter.currentPage = .list
//            }, label: {
//                Text("Show in list")
//            })
//        })
//    }
//}
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView().environmentObject(ViewRouter())
//    }
//}

import SwiftUI
import UIKit


struct MapView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack(content: {
            VStack {
              
                GoogleMapsView()
//                        .edgesIgnoringSafeArea(.top)
//                        .frame(height: 300)
                    }
//            Text("This is the map page.")
//            Button(action: {
//                viewRouter.currentPage = .list
//            }, label: {
//                Text("Show in list")
//            })
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(ViewRouter())
    }
}
