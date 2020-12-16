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
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State var loading = true
    @State var error = false
    @State var showMenu = false
    @State var havePlan = true
    @State var plans: [String]?
    @State var plan: Plan?
    @State var destinations: [[Destination]]?
    @State var placeId: String = ""
    @State var dayIndex = 0
    @State var planIndex = 0
    
    let originalOffset: CGFloat = UIScreen.main.bounds.size.width/3*2.3  // 320
    @State var offset: CGFloat = UIScreen.main.bounds.size.width/3*2.3  // 320
    
    var body: some View {
        VStack {
            if (loading) {
                LoadingView()
            }
            if (error) {
                Text("Error. Doh!")
            }
            if (!havePlan) {
                VStack {
                    Text("You got no plan.")
                    Button(action: {
                        self.addPlan()
                    }) {
                        MenuButton(text: "create a new plan")
                    }
                }
            }
            if (plan != nil && destinations != nil) {
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        if (showMenu) {
                            MenuView(
                                planId: self.plan!.id,
                                users: self.plan!.users,
                                destinations: self.destinations!,
                                showMenu: self.$showMenu
                            ).frame(width: originalOffset)
                        }
                        SwitcherView(
                            name: self.plan!.id,
                            destinations: self.destinations!,
                            users: self.plan!.users,
                            planId: self.plan!.id,
                            showMenu: self.$showMenu,
                            loading: self.$loading
                        )
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
        
        API().getUser(userAccount: userData.currentUser.account) { result in
            
            switch result {
            case .success(let user):
                self.plans = user.plans
            case .failure:
                self.error = true
            }
            group.leave()
        }
        
        group.wait()
        
        var destinations: [[Destination]]? = nil
        if (self.plans!.count > 0) {
            group.enter()
            self.havePlan = true
            API().getPlan(planId: self.plans![self.planIndex]) { result in
                
                switch result {
                case .success(let plan):
                    self.plan = plan
                case .failure:
                    self.error = true
                }
                group.leave()
            }
            
            group.wait()
            
            destinations = self.getDestinations(group: group)
        }
        
        group.notify(queue: .main) {
            if (destinations == nil) {
                self.havePlan = false
            } else if (destinations != self.destinations) {
                self.destinations = destinations
            }
            self.loading = false
        }
    }
    
    func getDestinations(group: DispatchGroup) -> [[Destination]] {
        var destinations: [[Destination]] = []
        for (dayIndex, day) in self.plan!.destinations.enumerated() {
            destinations.append([])
            for locationId in day {
                group.enter()
                var id = ""
                var img = ""
                var name = ""
                var address = ""
                var coordinate = Coordinate(latitude: 0.0, longitude: 0.0)
                GoogleAPI().getLocation(locationId: locationId) { result in
                    switch result {
                    case .success(let location):
                        id = location.result.place_id
                        img = (location.result.photos != nil) ? location.result.photos![0].photoReference : "unknown_destination"
                        name = location.result.name
                        address = location.result.formatted_address
                        coordinate = Coordinate(
                            latitude: location.result.geometry.location.latitude,
                            longitude: location.result.geometry.location.longitude
                        )
                    case .failure:
                        self.error = true
                    }
                    group.leave()
                }
                group.wait()
                var comments: [String] = []
                var ratings: Float = 0
                for userAccount in self.plan!.users {
                    group.enter()
                    API().getComment(userAccount: userAccount, locationId: locationId) { result in
                        switch result {
                        case .success(let comment):
                            comments.append(comment.content)
                            ratings += Float(comment.rating)
                        case .failure:
                            self.error = true
                        }
                        group.leave()
                    }
                    group.wait()
                }
                let destination = Destination(id: id, img: img, name: name, address: address, cooridinate: coordinate,
                                              comments: comments, rating: ratings / Float(self.plan!.users.count))
                destinations[dayIndex].append(destination)
            }
        }
        return destinations
    }
    
    func addPlan() {
        API().addPlan(userAccount: userData.currentUser.account) { result in
            switch result {
            case .success:
                break
            case .failure:
                self.error = true
            }
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
