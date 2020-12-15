//
//  MapView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/30.
//

import SwiftUI
import UIKit


struct MapView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        GoogleMapsView()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(ViewRouter())
    }
}
