

import SwiftUI
import UIKit


struct MapView: View {
    
//    @EnvironmentObject var viewRouter: ViewRouter
    let destinations: [[Destination]]
    @Binding var dayIndex: Int
    @State var isactive: [Bool]
    let users: [String]
    init(destinations: [[Destination]],dayIndex: Binding<Int>, users: [String]){
        self._dayIndex = dayIndex
        self.destinations = destinations
        self._isactive = State(initialValue: [Bool](repeating: false, count: destinations[dayIndex.wrappedValue].count))
        self.users = users

    }
    
    
    var body: some View {
        

//        }
        GoogleMapsView(destinations: destinations,dayIndex: dayIndex, isactive: $isactive)
        
        //
        ForEach(destinations[dayIndex].indices) {
            (index) in
            NavigationLink("", destination: DestinationView(destination: destinations[dayIndex][index],users: self.users), isActive: $isactive[index])
            
        }
  
        }
//
                    
                
                    
                

        
    
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

