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
    @Environment(\.colorScheme) var colorScheme
    @State private var showLoadingIndicator: Bool = true
    var body: some View {
       let size = UIScreen.main.bounds.size.width / 4
           VStack() {
               ActivityIndicatorView(isVisible: self.$showLoadingIndicator, type: .default)
                   .frame(width: size, height: size)
                   .foregroundColor(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
            Text("Loading").font(.title).fontWeight(.bold).foregroundColor(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
           }.ignoresSafeArea(edges:.all)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .preferredColorScheme(.dark)
    }
}
