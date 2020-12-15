//
//  ListView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/30.
//

import SwiftUI

struct ListBlock: View {
    let destination: Destination
    let users: [String] = ["guest"]
    @State var rating: Int
    
    init(destination: Destination) {
        self.destination = destination
        self._rating = State(initialValue: destination.rating)
    }
    
    var body: some View {
        NavigationLink(destination: DestinationView(destination: destination, users: users)) {
            HStack(alignment: .center, spacing: 20) {
                Image(self.destination.img)
                    .resizable()
                    .cornerRadius(10)
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(self.destination.name)").bold()
                    HeartRating(rating: $rating).disabled(true)
                }
                Spacer()
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color(UIColor.tertiarySystemBackground))
        }
    }
}

struct DayView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    let dayIndex: Int
    let destinations: [Destination]

    var body: some View {
        VStack(alignment: .center) {
            Text("Day \(dayIndex)")
                .frame(width: 80, height: 20)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(15)
            ScrollView {
                VStack {
                    ForEach(destinations) { des in
                        ListBlock(destination: des)
                    }
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }.background(Color(UIColor.secondarySystemBackground))
        }.padding(.top, 90)
    }
}

struct DaysView: View {
    let destinations: [[Destination]]
    
    @Binding var dayIndex: Int
    @State var originalOffset: CGFloat = 0
    @State var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { g in
            HStack(spacing: 0) {
                ForEach(destinations.indices, id: \.self) { dayIndex in
                    DayView(
                        dayIndex: dayIndex,
                        destinations: destinations[dayIndex]
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
            )
        }.animation(.default)
    }
    
    func handleDragging(translation: CGSize) {
        if (self.destinations.count == 1) {
            return
        }
        if ((self.dayIndex > 0 && self.dayIndex < self.destinations.count - 1) ||
            (self.dayIndex == self.destinations.count - 1 && translation.width > 0) ||
            (self.dayIndex == 0 && translation.width < 0)) {
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
            if (self.dayIndex != self.destinations.count - 1) {
                self.dayIndex += 1
            }
        } else if (direction == "right") {
            if (self.dayIndex != 0) {
                self.dayIndex -= 1
            }
        }
        self.offset = -CGFloat(self.dayIndex) * UIScreen.screenWidth
    }
}

struct ListView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    let name: String
    let destinations: [[Destination]]
    let users: [String]
    @Binding var dayIndex: Int

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(UIColor.systemTeal))
                .frame(height: 200)
            VStack(alignment: .center) {
                Text(name)
                DaysView(destinations: destinations, dayIndex: $dayIndex)
            }
        }.ignoresSafeArea(edges:.bottom)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper().environmentObject(ViewRouter())
    }
    struct PreviewWrapper: View {

        @State var destinations: [[Destination]] = [
            [Destination(id: "", img: "unknown_destination", name: "Test", address: "Address Test", cooridinate: Coordinate(latitude: 0.0, longitude: 0.0), comments: [], rating: 3)]
        ]
        @State var users: [String] = [
            "guest"
        ]
        @State var dayIndex = 0
        @State var showMenu = false

        var body: some View{
            ListView(name: "", destinations: destinations, users: users, dayIndex: $dayIndex)
        }
    }
}
