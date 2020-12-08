//
//  ContentView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/25.
//

import SwiftUI

enum Page {
    case list
    case map
}

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var loading = false
    @State var error = false
    @State var plan: Plan?
    @State var destinations: [[Destination]]?
    
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
                        name: plan!.id,
                        destinations: destinations!,
                        users: plan!.users,
                        planId: plan!.id
                    )
                case .map:
                    MapView()
                }
            }
        }
        .onAppear(perform: fetchData)
    }
    

    func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        loading = true
        error = false
        
        API().getPlan(planId: "89d00493-f8a9-43df-aa2a-f716b5d82adb") { result in
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
                API().getLocation(locationId: locationId) { result in
                    switch result {
                    case .success(let location):
                        let destination = Destination(
                            id: location.id,
                            img: location.img,
                            name: location.name,
                            address: location.address,
                            cooridinate: location.coordinate,
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
