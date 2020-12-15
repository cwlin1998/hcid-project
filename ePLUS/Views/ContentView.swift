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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var loading = true
    @State var error = false
    @State var showMenu = false
    @State var plans: [String]?
    @State var plan: Plan?
    @State var destinations: [[Destination]]?
    @State var placeId: String = ""
    @State var dayIndex = 0
    
    let originalOffset: CGFloat = 320
    @State var offset: CGFloat = 320
    
    var body: some View {
        VStack {
            if (loading) {
                Text("Loading...")
            }
            if (error) {
                Text("Error. Doh!")
            }
            if (plan != nil && destinations != nil) {
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        if (showMenu) {
                            MenuView(
                                planId: self.plan!.id,
                                destinations: self.destinations!,
                                showMenu: self.$showMenu
                            ).frame(width: originalOffset)
                        }
                        SwitcherView(
                            name: self.plan!.id,
                            destinations: self.destinations!,
                            users: self.plan!.users,
                            planId: self.plan!.id,
                            showMenu: self.$showMenu                        )
                        .frame(width: g.frame(in: .global).width)
                        .offset(x: self.showMenu ? self.offset: 0)
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if (value.translation.width < 0 && value.translation.width > -originalOffset) {
                                    self.offset = originalOffset + value.translation.width
                                }
                            }
                            .onEnded { value in
                                if value.translation.width < -100 {
                                    withAnimation {
                                        self.showMenu = false
                                    }
                                }
                                self.offset = originalOffset
                            }
                    )
                }
            }
        }
        .onAppear(perform: fetchData)
        .onReceive(timer) { _ in
            self.fetchData()
        }
    }
    
    func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        
        API().getUser(userAccount: "guest") { result in
            
            switch result {
            case .success(let user):
                self.plans = user.plans
            case .failure:
                self.error = true
            }
            group.leave()
        }
        
        group.wait()
        group.enter()
        
        API().getPlan(planId: self.plans![0]) { result in
            
            switch result {
            case .success(let plan):
                self.plan = plan
            case .failure:
                self.error = true
            }
            group.leave()
        }
        
        group.wait()
        
        var destinations: [[Destination]] = []
        for (dayIndex, day) in self.plan!.destinations.enumerated() {
            destinations.append([])
            for locationId in day {
                group.enter()
                GoogleAPI().getLocation(locationId: locationId) { result in
                    switch result {
                    case .success(let location):
                        let destination = Destination(
                            id: location.result.place_id,
                            img: "unknown_destination",
                            name: location.result.name,
                            address: location.result.formatted_address,
                            cooridinate: Coordinate(
                                latitude: location.result.geometry.location.latitude,
                                longitude: location.result.geometry.location.longitude
                            ),
                            comments: [],
                            rating: 2
                        )
                        destinations[dayIndex].append(destination)
                    case .failure:
                        self.error = true
                    }
                    group.leave()
                }
                group.wait()
            }
        }
        
        group.notify(queue: .main) {
            if (destinations != self.destinations) {
                self.destinations = destinations
            }
            self.loading = false
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewRouter())
            .environmentObject(DayRouter())
    }
}
