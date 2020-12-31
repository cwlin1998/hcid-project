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
    @Binding var loading: Bool

    @Binding var isactive: [[Bool]]
    @State var routing: Bool = false
    
    @State private var isrouteValid: Bool = false
    @State private var shouldShowRouteAlert: Bool = false
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
                        // side menu button
                        if (!self.routing) {
                            Button(action: {
                                withAnimation {
                                   self.showMenu.toggle()
                                }
                            }) {
                                Image(systemName: self.showMenu ? "chevron.backward.square.fill" : "chevron.forward.square.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(UIColor.systemIndigo))
                                    .imageScale(.large)
                            }
                        }

                        Spacer()
                        Text(name).font(.title).fontWeight(.bold).foregroundColor(Color.black)
                        Spacer()
                        
                        // Route button
                        NavigationLink(destination: RoutingView(destinations: self.destinations), isActive: self.$isrouteValid) {
                            Image(systemName: "paperplane.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(UIColor.systemIndigo))
                                .imageScale(.large)
                                .onTapGesture {
                                    if destinations[dayRouter.dayIndex].count > 1 {
                                        isrouteValid = true
                                    }
                                    if !isrouteValid {
                                        self.shouldShowRouteAlert = true //trigger Alert
                                    }
                                }
                        }

                        // list/map button
                        Button(action: {
                            viewRouter.currentPage = (viewRouter.currentPage == .map) ? .list : .map
                            self.routing = false
                        }, label: {
                            Image(systemName: (viewRouter.currentPage == .map) ? "list.dash": "map.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(UIColor.systemIndigo))
                                .imageScale(.large)
                        })
                        
                        // add destination button
                        NavigationLink(destination: AddDestinationView(planId: planId, dayIndex: dayRouter.dayIndex)) {
                            Image(systemName: "plus.app.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(UIColor.systemIndigo))
                                .imageScale(.large)
                        }
                    }.padding(.horizontal, 8)
                    Spacer()
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }.ignoresSafeArea(edges:.bottom)
        .navigationBarTitle("")
        .navigationBarHidden(true)
            .alert(isPresented: $shouldShowRouteAlert) {
                Alert(title: Text("At least need two destinations!"))
            }
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
