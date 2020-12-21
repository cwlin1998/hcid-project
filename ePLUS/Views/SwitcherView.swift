//
//  SwitcherView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/12.
//

import SwiftUI

struct SwitcherView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var dayRouter: DayRouter
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorScheme
    
    let name: String
    let destinations: [[Destination]]
    let users: [String]
    let planId: String
    @Binding var showMenu: Bool
    @State var dayIndex: Int = 0
    @Binding var loading: Bool

    @Binding var isactive: [[Bool]]
    var body: some View {
//        NavigationView(){
            ZStack(alignment: .topLeading) {
                VStack {
                    switch viewRouter.currentPage {
                    case .list:
                        ListView(planId: planId, name: name, destinations: destinations, users: users, showMenu: self.$showMenu)
                    case .map:
                        MapView(destinations: destinations, users: users, isactive: self.isactive, showMenu: self.$showMenu)
                    }
                }.disabled(self.showMenu ? true : false)
                VStack(alignment: .trailing, spacing: 10) {
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation {
                               self.showMenu.toggle()
                            }
                        }) {
                            Image(systemName: self.showMenu ? "chevron.backward.square.fill" : "chevron.forward.square.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                                .imageScale(.large)
                        }
                        Spacer()
                        Text(name).font(.title).fontWeight(.bold).foregroundColor(Color.black)
                        Spacer()
                        Button(action: {
                            viewRouter.currentPage = (viewRouter.currentPage == .map) ? .list : .map
                        }, label: {
                            Image(systemName: (viewRouter.currentPage == .map) ? "list.dash": "map.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                                .imageScale(.large)
                        })
                        NavigationLink(destination: AddDestinationView(planId: planId, dayIndex: dayRouter.dayIndex)) {
//                            Text("+")
                            Image(systemName: "plus.app.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                                .imageScale(.large)
                        }
                    }.padding(.horizontal, 8)
                    Spacer()
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }.ignoresSafeArea(edges:.bottom)
        .navigationBarTitle("")
        .navigationBarHidden(true)
//        }
    }
}

struct SwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
            .environmentObject(ViewRouter())
            .environmentObject(DayRouter())
            .environmentObject(UserData())
    }
    struct PreviewWrapper: View {

        @State var destinations: [[Destination]] = [
            [Destination(id: "", img: "unknown_destination", name: "Test", address: "Address Test", cooridinate: Coordinate(latitude: 0.0, longitude: 0.0), comments: [:], rating: 3)]
        ]
        @State var users: [String] = [
            "guest"
        ]
        @State var showMenu = false
        @State var dayIndex = 0

        var body: some View{
            SwitcherView(name: "", destinations: destinations, users: users, planId: "", showMenu: $showMenu, loading: .constant(false), isactive: .constant([[false]]))
        }
    }
}
