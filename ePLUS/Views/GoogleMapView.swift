import SwiftUI
import GoogleMaps
struct markerInfoWindow: View {
    
    var body: some View {
        VStack(
        ){
        ZStack(alignment : .bottom
        ){
//            Image("Tag description").resizable().frame(width: 200, height: 20,alignment: .bottom)
            VStack(
            ){
            HStack(alignment : .center){
                Text("New York")
                Text("4").foregroundColor(Color.red)
                Image("heartfill").resizable().frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
//                Spacer();
                
            }.frame(width: 200, height: 20, alignment: .bottom)
    
             
        }.frame(width: 200, height: 20,alignment: .bottom)
        }
    }}
struct GoogleMapsView: UIViewRepresentable {
    private let zoom: Float = 15.0
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        GMSServices.provideAPIKey("AIzaSyAnU8CmfDD8S3X6xAYvlScSwvhrm2mht2A");

        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        let marker = GMSMarker();
        
        marker.position = CLLocationCoordinate2D(latitude:  -32, longitude:  150    );
    
//        marker.title = "NewYork";
//        marker.snippet = "123";
        
        marker.map=mapView
        marker.icon = UIImage(named: "Marker")
        mapView.delegate = context.coordinator
        return mapView
    }
    func makeCoordinator() -> Coordinator {
           Coordinator(owner: self)
        }
    func updateUIView(_ mapView: GMSMapView, context: Context) {

    }
    class Coordinator: NSObject, GMSMapViewDelegate {
           let owner: GoogleMapsView       // access to owner view members,

           init(owner: GoogleMapsView) {
             self.owner = owner
           }
        func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
            print("Showing marker infowindow")
            let callout = UIHostingController(rootView: markerInfoWindow())
            
            callout.view.frame = CGRect(x: 0, y: 0, width: 150, height: 20)
//            callout.view.backgroundColor = .clear
            return callout.view
        }

             // ... delegate methods here
        }
}

struct GoogleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        markerInfoWindow()
    }
}

