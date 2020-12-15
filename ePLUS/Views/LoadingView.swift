//
//  LoadingView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/12.
//

import SwiftUI
import ActivityIndicatorView

/*
 Notice:
 please add [pod 'ActivityIndicatorView']  in your Podfile
 and run pod install
 */

struct LoadingView: View {
    @State private var showLoadingIndicator: Bool = true
    var body: some View {
       let size = UIScreen.main.bounds.size.width / 4
           VStack() {
               ActivityIndicatorView(isVisible: self.$showLoadingIndicator, type: .default)
                   .frame(width: size, height: size)
                   .foregroundColor(Color(UIColor.systemIndigo))
            Text("Loading").font(.title).fontWeight(.bold).foregroundColor(Color(UIColor.systemIndigo))
           }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .preferredColorScheme(.dark)
    }
}
