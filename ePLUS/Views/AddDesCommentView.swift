//
//  addDesCommentView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/8.
//

import SwiftUI
import MapKit

struct InformationBlock: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var loading: Bool
    @Binding var error: Bool
    let planId: String
    let dayIndex: Int
    let placeId: String
    @Binding var searching: Bool
    @State var destination: Destination?
    @State private var commentText: String = ""
    
    @State var currentRating: Float = 0
    @State var img: Image
    
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack (alignment: .top) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
                .opacity(0.8)
                .padding(.top, UIScreen.screenWidth*0.15)
            VStack(alignment: .leading, spacing: 15){
                HStack (alignment: .bottom, spacing: 30){
                    // Image
                    self.img
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.screenWidth*0.3, height: UIScreen.screenWidth*0.3).cornerRadius(15)
                    // Address
                    Text(self.destination!.address)
                        .font(.system(size: 15))
                        .frame(width: 120, height: UIScreen.screenWidth*0.15)
                }
                VStack(alignment: .leading, spacing: 2) {
                    // Location name
                    Text(self.destination!.name)
                        .font(.system(size: 36))
                        .fontWeight(.bold)
                    HeartRating(rating: $currentRating)
                }
                // Comment editing
                TextArea("Make your comment here...", text: $commentText)
                
                // Add to plan button
                RoundedRectButton(action: {
                    if self.currentRating == 0 {
                        self.showAlert = true
                    }
                    else {
                        self.addDestination()
                        self.addComment()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, text: "Add to plan")
                
            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        }
        .padding(.horizontal, 10)
        .frame(height: UIScreen.screenHeight*0.6)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Remember to give the rating!"))
        }
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
    
    func addComment() {
        let comment = Comment(
            locationId: self.placeId,
            content: self.commentText,
            rating: Int(self.currentRating)
        )
        API().addComment(userAccount: userData.currentUser.account, comment: comment) { result in
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
    @EnvironmentObject var userData: UserData
    @State var loading = false
    @State var error = false
    let planId: String
    let dayIndex: Int
    let placeId: String
    @Binding var searching: Bool
    @State var destination: Destination?
    
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
                LoadingView()
            }
            if (destination != nil && region.center.latitude != 0){
                ZStack{
                    Map(coordinateRegion: $region).ignoresSafeArea(edges: .all)
                    
                    // Foreground
                    VStack(alignment: .leading) {
                        ReturnButton(action: {
                            self.searching = true
                        }, size: 40)
                        
                        Spacer()
                            
                        InformationBlock(loading: $loading, error: $error, planId: planId, dayIndex: dayIndex,
                                         placeId: placeId, searching: $searching, destination: destination, img: fetchImg(reference: destination!.img))
                        
                    }.padding()
                }
            }
        }.onAppear(perform: fetchDestinations)
    }
    
    func fetchImg(reference: String) -> Image {
        if reference == "unknown_destination" {
            return Image("unknown_destination")
        }
        let urlStr = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=AIzaSyBP-OM2AulCwjnQV8IN72HdH-w12umJpxQ"
        if let url = URL(string: urlStr), let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
        }
        return Image("unknown_destination")
    }
    
    func fetchDestinations() {
        loading = true

        GoogleAPI().getLocation(locationId: placeId) { result in
            switch result {
            case .success(let location):
                self.loading = false
                let destination = Destination(
                    id: location.result.place_id,
                    img: location.result.photos != nil ? location.result.photos![0].photoReference : "unknown_destination",
                    name: location.result.name,
                    address: location.result.formatted_address,
                    cooridinate: Coordinate(
                        latitude: location.result.geometry.location.latitude,
                        longitude: location.result.geometry.location.longitude
                    ),
                    comments: [:],
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
            .environmentObject(UserData())
    }
}

struct AddDesCommentView_Previews: PreviewProvider {
    static var previews: some View {
        AddDesCommentView_Previews_Container()
    }
}

