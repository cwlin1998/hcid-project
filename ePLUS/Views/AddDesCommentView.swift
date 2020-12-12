//
//  addDesCommentView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/8.
//

import SwiftUI
import MapKit

struct InformationBlock: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var loading: Bool
    @Binding var error: Bool
    let planId: String
    let dayIndex: Int
    let placeId: String
    @Binding var searching: Bool
    @State var destination: Destination?
    @State private var commentText: String = ""
    
    @State var currentRating: Int = 0
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
                .opacity(0.8)
                .padding(.top, 16)
            VStack(alignment: .leading, spacing: 15){
                HStack (alignment: .bottom, spacing: 30){
                    // Image
                    Image(self.destination!.img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth*0.3, height: UIScreen.screenWidth*0.3).cornerRadius(15)
                    // Address
                    Text(self.destination!.address)
                        .font(.system(size: 15))
                        .frame(width: 120, height: UIScreen.screenWidth*0.15)
                }
                VStack(alignment: .leading, spacing: 0) {
                    // Location name
                    Text(self.destination!.name)
                        .font(.system(size: 36))
                    
                    HeartRating(rating: $currentRating)
                }

                // Comment editing
                TextArea("Make your comment here...", text: $commentText)
                
                // Add to plan button
                RoundedRectButton(action: {
                    self.addDestination()
                    // TODO: Update user data
                    self.presentationMode.wrappedValue.dismiss()
                }, text: "Add to plan")
                
            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        }
        .padding(.horizontal, 10)
        .frame(height: UIScreen.screenHeight*0.50)
    }
    
    func addDestination() {
        API().addDestination(planId: self.planId, dayIndex: self.dayIndex, locationId: self.placeId) { result in
            switch result {
            case .success:
                self.error = false
            case .failure:
                self.error = true
            }
        }
    }
    
}

struct AddDesCommentView: View {
    @State var loading = false
    @State var error = false
    let planId: String
    let dayIndex: Int
    let placeId: String
    @Binding var searching: Bool
    
    @State var destination: Destination?
//    @State var destination: Destination? = Destination(id: "ChIJZQD10CZawokRCuvDW1oLE-Y", img: "columbusPark", name: "Columbus Park", address: "Mulberry Street &, Baxter St, New York, NY 10013, USA", cooridinate: Coordinate(latitude: 40.7155353, longitude: -74.0000483), comments: [""], rating: 3)
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 0,
            longitude: 0
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    
    var body: some View {
        VStack{
            if (loading) {
                Text("Loading...")
            }
            if (destination != nil && region.center.latitude != 0){
                ZStack{
                    // Map Background
                    // Image("addDesCommentbg")
                    //     .resizable()
                    //     .scaledToFill()
                    //     .frame(width: UIScreen.screenWidth)
                    //     .ignoresSafeArea(edges: .all)
                    
                    Map(coordinateRegion: $region).ignoresSafeArea(edges: .all)
                    
                    // Foreground
                    VStack(alignment: .leading) {
                        ReturnButton(action: {
                            self.searching = true
                        })
                        
                        Spacer()
                            
                        InformationBlock(loading: $loading, error: $error, planId: planId, dayIndex: dayIndex,
                                             placeId: placeId, searching: $searching, destination: destination)
                        
                    }.padding()
                }
            }
        }.onAppear(perform: fetchDestinations)
    }
    
    func fetchDestinations() {
        loading = true

        GoogleAPI().getLocation(locationId: placeId) { result in
            switch result {
            case .success(let location):
                self.loading = false
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
                    rating: 4
                )
                self.destination = destination
                self.region.center = CLLocationCoordinate2D(
                    latitude: destination.cooridinate.latitude,
                    longitude: destination.cooridinate.longitude)
            case .failure:
                self.error = true
            }
        }
    }
}

struct AddDesCommentView_Previews_Container: View {
    @State var searching: Bool = true
    var body: some View {
        AddDesCommentView(planId: "", dayIndex: 0, placeId: "", searching: $searching)
    }
}

struct AddDesCommentView_Previews: PreviewProvider {
    static var previews: some View {
        AddDesCommentView_Previews_Container()
    }
}

