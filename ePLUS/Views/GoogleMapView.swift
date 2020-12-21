import SwiftUI
import GoogleMaps
struct markerInfoWindow: View {
    var name : String
    var stars: String
    var users: [String] = ["guest"]
    var destination: Destination
    var body: some View {
        VStack{
            Spacer()
            ZStack {
                Image("Tag description").resizable().frame(width: 320, height: 150)
                HStack {
                    Text(name).font(.title3).foregroundColor(Color(UIColor.systemIndigo))
                    Text(stars).foregroundColor(Color.red).font(.title2)
                    Image("heartfill").resizable().frame(width: 20, height: 20)
                }.offset(y: -18)
            }.offset(y: 40)
        }
    }
    
}

struct GoogleMapsView: UIViewRepresentable {
    let destinations: [[Destination]]
    let dayIndex: Int
    @Binding var isactive: [Bool]
    
    
    func makeUIView(context: Self.Context) -> GMSMapView {

        GMSServices.provideAPIKey("AIzaSyAnU8CmfDD8S3X6xAYvlScSwvhrm2mht2A")
        var camera = GMSCameraPosition.camera(withLatitude:25.0173405, longitude: 121.5375631, zoom: 15.0)
        if (destinations[dayIndex].count>0){
            camera = GMSCameraPosition.camera(withLatitude: destinations[dayIndex][0].cooridinate.latitude , longitude: destinations[dayIndex][0].cooridinate.longitude , zoom: 15.0)
            
        }
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        var marker = GMSMarker()
        var des: Destination
        //
        if (destinations[dayIndex].count>0){
            for index in 0...destinations[dayIndex].count-1{
                    des = destinations[dayIndex][index]
                    marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude:  des.cooridinate.latitude, longitude:  des.cooridinate.longitude    )
        //            marker.title = des.name
                    marker.snippet = String(index)
                    marker.map = mapView
                    marker.icon = UIImage(named: "Marker")!.imageResized(to: CGSize(width: 30, height: 40))
                    marker.userData = des
                    mapView.delegate = context.coordinator
            }
        }
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(owner: self)
        }
    func updateUIView(_ mapView: GMSMapView, context: Context) {    }
    class Coordinator: NSObject, GMSMapViewDelegate {
           let owner: GoogleMapsView
           init(owner: GoogleMapsView) {
             self.owner = owner
           }
        func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//            print("Showing marker infowindow")
            let callout = UIHostingController(rootView: markerInfoWindow(
                                                name: String((marker.userData as! Destination).name) ,stars: String((marker.userData as! Destination).rating) ,destination: marker.userData as! Destination)
            )
            callout.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            callout.view.backgroundColor = .clear

            return callout.view
        }
        func mapView(_ mapView: GMSMapView, didTapInfoWindowOf didTapInfoWindowOfMarker: GMSMarker) {
                print("You tapped a marker's infowindow!")
//            print(didTapInfoWindowOfMarker)
            let currentId: Int = Int(didTapInfoWindowOfMarker.snippet ?? "0") ?? 0
            self.owner.isactive[currentId] = true
//            print(self.owner.isactive)
                    return
            }
        }
}

//struct GoogleMapsView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        markerInfoWindow(name: "Taiwan",stars: "4")
//    }
//}


