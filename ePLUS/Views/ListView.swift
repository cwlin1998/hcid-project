//
//  ListView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/30.
//

import SwiftUI

struct ListBlock: View {
    @EnvironmentObject var dayRouter: DayRouter
    
    let planId: String
    let destination: Destination
    let users: [String]
    @State var rating: Float
    @State var showDeleteAlert: Bool = false
    
    init(planId: String, destination: Destination, users: [String]) {
        self.planId = planId
        self.destination = destination
        self.users = users
        self._rating = State(initialValue: destination.rating)
    }
    
    var body: some View {
        NavigationLink(destination: DestinationView(destination: destination, users: users)) {
            HStack(spacing: 20) {
                GooglePlaceImage(url: self.destination.img, width: 60, height: 60, cornerRadius: 10)
                    .offset(x: 16)
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(self.destination.name)")
                        .bold()
                        .foregroundColor(Color(UIColor.systemIndigo))
                    HeartRating(rating: $rating).disabled(true)
                }
                .offset(x: 16)
                Spacer()
            }
//            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 88)
            .background(Color(UIColor.tertiarySystemBackground))
            .cornerRadius(10)
            .contextMenu{
                VStack {
                    Button(action: {
                        self.showDeleteAlert = true
                    }){
                        Image(systemName: "trash")
                        Text("Delete")
                        .foregroundColor(.red)
                    }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Remove \(self.destination.name) from Day \(dayRouter.dayIndex+1)?"),
                    message: Text("The action cannot be recovered"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {
                            self.deleteDestination()
                        }
                    )
                )
            }
        }
    }
    
    func deleteDestination() {
        API().deleteDestination(planId: self.planId, dayIndex: dayRouter.dayIndex, locationId: self.destination.id) { result in
            switch result{
            case .success:
                print("delete \(self.destination.name) from day \(dayRouter.dayIndex)")
            case .failure:
                print("delete failure!")
            }
        }
    }
}

struct DayView: View {
    let planId: String
    let dayIndex: Int
    let destinations: [Destination]
    let users: [String]

    var body: some View {
        VStack(alignment: .center) {
            Text("Day \(dayIndex + 1)")
                .frame(width: 80, height: 20)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(Color(UIColor.tertiarySystemBackground))
                .opacity(0.85)
                .cornerRadius(50)
            ScrollView {
                VStack(spacing: 16) { // space bewtween destinations
                    ForEach(destinations) { des in
                        ListBlock(planId: planId, destination: des, users: users)
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 36)
                .offset(y: 16)  // space with plan img
            }.background(Color(UIColor.secondarySystemBackground))
        }
    }
}

struct DaysView: View {
    @EnvironmentObject var dayRouter: DayRouter
    
    let planId: String
    let destinations: [[Destination]]
    let users: [String]
    
    @State var originalOffset: CGFloat = 0
    @State var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { g in
            HStack(spacing: 0) {
                ForEach(destinations.indices, id: \.self) { dayIndex in
                    DayView(
                        planId: planId, dayIndex: dayIndex,
                        destinations: destinations[dayIndex],
                        users: users
                    ).frame(width: g.frame(in: .global).width)
                }
            }
            .offset(x: self.offset)
            .highPriorityGesture(
                DragGesture()
                    .onChanged({ value in
                        self.handleDragging(translation: value.translation)
                    })
                    .onEnded({ value in
                        self.handleDragged(translation: value.translation)
                    })
            ).onReceive(dayRouter.objectWillChange, perform: self.updateOffset)
        }.animation(.default)
    }
    
    func updateOffset() {
        self.offset = -CGFloat(dayRouter.dayIndex) * UIScreen.screenWidth
        self.originalOffset = self.offset
    }
    
    func handleDragging(translation: CGSize) {
        if (self.destinations.count == 1) {
            return
        }
        if ((dayRouter.dayIndex > 0 && dayRouter.dayIndex < self.destinations.count - 1) ||
            (dayRouter.dayIndex == self.destinations.count - 1 && translation.width > 0) ||
            (dayRouter.dayIndex == 0 && translation.width < 0)) {
            self.offset = self.originalOffset + translation.width
        }
    }
    
    func handleDragged(translation: CGSize) {
        if (translation.width > 50) {
            self.changeView(direction: "right")
        } else if (-translation.width > 50) {
            self.changeView(direction: "left")
        } else {
            self.changeView(direction: "")
        }
        self.originalOffset = self.offset
    }
    
    func changeView(direction: String) {
        if (direction == "left") {
            if (dayRouter.dayIndex != self.destinations.count - 1) {
                dayRouter.dayIndex += 1
            }
        } else if (direction == "right") {
            if (dayRouter.dayIndex != 0) {
                dayRouter.dayIndex -= 1
            }
        }
        self.offset = -CGFloat(dayRouter.dayIndex) * UIScreen.screenWidth
    }
}

struct ListView: View {
    @EnvironmentObject var dayRouter: DayRouter
    
    let planId: String
    let name: String
    let destinations: [[Destination]]
    let users: [String]
    @State var uiImage: UIImage = UIImage(named: "zuccottiPark")!

    var body: some View {
        ZStack(alignment: .top) {
            Color(UIColor.secondarySystemBackground).ignoresSafeArea()
            RemoteImage(url: "https://picsum.photos/800/450/?blur", width: Float(UIScreen.main.bounds.size.width), height: Float(UIScreen.main.bounds.size.width/16*9), cornerRadius: 0)
            Text(name).font(.title).fontWeight(.bold).offset(y: 16)
            VStack(alignment: .center) {
                DaysView(planId: planId, destinations: destinations, users: users)
            }.offset(y: UIScreen.main.bounds.size.width/16*6)
        }.ignoresSafeArea(edges:.bottom)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper().environmentObject(DayRouter())
    }
    struct PreviewWrapper: View {

        @State var destinations: [[Destination]] = [
            [Destination(id: "", img: "unknown_destination", name: "Test", address: "Address Test", cooridinate: Coordinate(latitude: 0.0, longitude: 0.0), comments: [], rating: 3),
             Destination(id: "", img: "unknown_destination", name: "Test", address: "Address Test", cooridinate: Coordinate(latitude: 0.0, longitude: 0.0), comments: [], rating: 3)],
            [Destination(id: "", img: "unknown_destination", name: "Test", address: "Address Test", cooridinate: Coordinate(latitude: 0.0, longitude: 0.0), comments: [], rating: 3)]
        ]
        @State var users: [String] = [
            "guest"
        ]
        @State var showMenu = false

        var body: some View{
            ListView(planId: "", name: "", destinations: destinations, users: users)
        }
    }
}
