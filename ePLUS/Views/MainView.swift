//
//  MainView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/17.
//

import SwiftUI


struct MainView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var dayRouter: DayRouter
    @EnvironmentObject var userData: UserData
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State var loading = true
    @State var error = false
    @State var showMenu = false
    @State var havePlan = true
    @State var account: String
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
                NavigationLink(destination: NewPlanView(havePlan: false, showMenu: $showMenu, planIndex: $planIndex)) {
                    VStack {
                        Text("You got no plan.")
                        MenuButton(text: "create a new plan")
                    }
                }
            }
            if (plan != nil && destinations != nil) {
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        SwitcherView(
                            name: self.plan!.name,
                            destinations: self.destinations!,
                            users: self.plan!.users,
                            planId: self.plan!.id,
                            showMenu: self.$showMenu,
                            loading: self.$loading
                        )
                        .frame(width: g.frame(in: .global).width)
                        .offset(x: self.showMenu ? self.offset: 0)
                        if (showMenu) {
                            MenuView(
                                planId: self.plan!.id,
                                users: self.plan!.users,
                                destinations: self.destinations!,
                                showMenu: self.$showMenu,
                                planIndex: $planIndex
                            ).frame(width: originalOffset)
                        }
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
        .navigationBarHidden(true)
    }
    
    func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        
        API().getUser(userAccount: self.account) { result in
            
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
            if (self.plans!.count == 0) {
                self.havePlan = false
            } else if (destinations != self.destinations) {
                self.destinations = destinations
            }
            userData.currentUser = User(account: self.account, password: self.account, nickname: self.account, plans:self.plans!, comments: [:])
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
                var comments: [String: String] = [:]
                var ratings: Float = 0
                for userAccount in self.plan!.users {
                    group.enter()
                    API().getComment(userAccount: userAccount, locationId: locationId) { result in
                        switch result {
                        case .success(let comment):
                            comments[userAccount] = comment.content
                            ratings += Float(comment.rating)
                        case .failure:
                            break
//                            self.error = true
                        }
                        group.leave()
                    }
                    group.wait()
                }
                let destination = Destination(id: id, img: img, name: name, address: address, cooridinate: coordinate,
                                              comments: comments, rating: ratings / Float(comments.count))
                destinations[dayIndex].append(destination)
            }
        }
        return destinations
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(account: "guest")
    }
}
