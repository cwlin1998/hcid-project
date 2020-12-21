

import SwiftUI
import UIKit


struct MapView: View {
    @EnvironmentObject var dayRouter: DayRouter
    
    let destinations: [[Destination]]
    let users: [String]
    @State var isactive: [[Bool]]
    @Binding var showMenu: Bool

    @State var originalOffset: CGFloat = 0
    @State var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { g in
            HStack(spacing:0 ){
                ForEach(destinations.indices, id: \.self) { dayIndex in
                    ZStack{
                        
                        GoogleMapsView(destinations: destinations,dayIndex: dayIndex, isactive: self.$isactive[dayIndex])
                    
                        ForEach(destinations[dayIndex].indices, id: \.self) { index in
                            NavigationLink("", destination: DestinationView(destination: destinations[dayIndex][index],users: self.users), isActive: self.$isactive[dayIndex][index])
                        }
                        
                        HStack(spacing: 8) {
                            if (dayIndex > 0) { DayBlock(day: dayIndex, showMenu: $showMenu) }
                            DayBlock(day: dayIndex+1, showMenu: $showMenu)
                            if (dayIndex+2 <= destinations.count) {DayBlock(day: dayIndex+2, showMenu: $showMenu)}
                        }
                        .frame(width: UIScreen.screenWidth*0.9, height: 100)
                        .offset(y: UIScreen.screenHeight/2-100)
                        
                    }
                    .ignoresSafeArea(.all)
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    .opacity((self.showMenu && dayIndex < dayRouter.dayIndex) ? 0 : 1)
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
//
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewWrapper().environmentObject(ViewRouter())
//    }
//    struct PreviewWrapper: View {
//
//        @State var destinations: [[Destination]] = [
//            [Destination(id: "", img: "unknown_destination", name: "Test", address: "Address Test", cooridinate: Coordinate(latitude: 0.0, longitude: 0.0), comments: [], rating: 3),
//             Destination(id: "", img: "unknown_destination", name: "Test", address: "Address Test", cooridinate: Coordinate(latitude: 0.0, longitude: 0.0), comments: [], rating: 3)],
//            [Destination(id: "", img: "unknown_destination", name: "Test", address: "Address Test", cooridinate: Coordinate(latitude: 0.0, longitude: 0.0), comments: [], rating: 3)]
//        ]
//        @State var users: [String] = [
//            "guest"
//        ]
//        @State var dayIndex = 0
//        @State var showMenu = false
//
//        var body: some View{
//            MapView( destinations: destinations, dayIndex: $dayIndex)
//        }
//    }
//}

