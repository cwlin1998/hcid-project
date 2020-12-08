//
//  ContentView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var loading = false
    @State var error = false
    @State var plans: [String]?
    @State var plan: Plan?
    @State var destinations: [[Destination]]?
    @State var placeId: String = ""
    
    var body: some View {
        VStack{
            if (loading) {
                Text("Loading...")
            }
            if (error) {
                Text("Error. Doh!")
            }
            if (plan != nil && destinations != nil) {
                switch viewRouter.currentPage {
                case .list:
                    Button(action:{
                        self.fetchData()
                    }, label:{
                        Text("Refresh")
                    })
                    ListView(
                        name: self.plan!.id,
                        destinations: self.destinations!,
                        users: self.plan!.users,
                        planId: self.plan!.id
                    )
                case .map:
                    MapView()
                case .search:
                    GoogleSearchView(placeId: self.$placeId)
                case .addDestination:
                    AddDesCommentView(planId: self.plan!.id, placeId: self.placeId)
                }
            }
        }
        .onAppear(perform: fetchData)
    }
    
    func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        loading = true
        
        API().getUser(userAccount: "guest") { result in
            
            switch result {
            case .success(let user):
                self.plans = user.plans
            case .failure:
                self.error = true
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.fetchPlan()
        }
    }

    func fetchPlan() {
        let group = DispatchGroup()
        
        group.enter()
        loading = true
        
        API().getPlan(planId: self.plans![0]) { result in
            self.loading = false
            
            switch result {
            case .success(let plan):
                self.plan = plan
            case .failure:
                self.error = true
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.fetchDestinations()
        }
    }
    
    func fetchDestinations() {
        self.destinations = []
        for (dayIndex, day) in self.plan!.destinations.enumerated() {
            self.destinations!.append([])
            for locationId in day {
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
                        self.destinations![dayIndex].append(destination)
                    case .failure:
                        self.error = true
                    }
                }
            }
        }
    }
    
//    func fetchDestinations() {
//        self.destinations = []
//        for (dayIndex, day) in self.plan!.destinations.enumerated() {
//            self.destinations!.append([])
//            for locationId in day {
//                API().getLocation(locationId: locationId) { result in
//                    switch result {
//                    case .success(let location):
//                        let destination = Destination(
//                            id: location.id,
//                            img: location.img,
//                            name: location.name,
//                            address: location.address,
//                            cooridinate: location.coordinate,
//                            comments: [],
//                            rating: 2
//                        )
//                        self.destinations![dayIndex].append(destination)
//                    case .failure:
//                        self.error = true
//                    }
//                }
//            }
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
