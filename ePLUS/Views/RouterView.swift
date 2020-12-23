


//
//  RouterView.swift
//  ePLUS
//
//  Created by kisaki on 2020/12/21.
//
import SwiftUI
import GoogleMaps
import SwiftyJSON

struct RoutingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var duration: String = "" //unit s
    @State var distance: String = "" //unit m
    let destinations: [[Destination]]
    var body: some View{
        ZStack  {
            RouterView(destinations: destinations, duration: duration, distance: distance)
            
            VStack (alignment: .leading) {
                ReturnButton(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, size: 30)
                Spacer()
                HStack {
                    Image(systemName: "figure.walk")
                        .font(.title)
                    Text("min")
                        .fontWeight(.semibold)
                        .font(.title)
                    Spacer()
                    Text("km")
                        .fontWeight(.semibold)
                        .font(.title)
                    Spacer()
                    Image(systemName: "paperplane.fill")
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .padding(.horizontal, 8)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 43/255, green: 185/255, blue: 222/255), Color(red: 124/255, green: 211/255, blue: 200/255)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40)
                .hidden()
            }
            .padding()
            .padding(.top, 50)
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
}



struct RouterView: UIViewRepresentable {
    @EnvironmentObject var dayRouter: DayRouter
    let destinations: [[Destination]]
    @State var duration: String
    @State var distance: String
    
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        GMSServices.provideAPIKey("AIzaSyAnU8CmfDD8S3X6xAYvlScSwvhrm2mht2A")
        var camera = GMSCameraPosition.camera(withLatitude:25.0173405, longitude: 121.5375631, zoom: 15.0)
        if (destinations[dayRouter.dayIndex].count>0){
            camera = GMSCameraPosition.camera(withLatitude: destinations[dayRouter.dayIndex][0].cooridinate.latitude , longitude: destinations[dayRouter.dayIndex][0].cooridinate.longitude , zoom: 15.0)
        }
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        var locarr: [String] = []
        var marker = GMSMarker()
        var des: Destination
        
        // get the top three rating
        var _destinations = destinations[dayRouter.dayIndex]
        _destinations.sort {
            $0.rating < $1.rating
        }
        let count = (_destinations.count>2) ? 3 : 2
        let _des = _destinations[0..<count]
        
        /*
        if (destinations[dayRouter.dayIndex].count>0){
            for index in 0...destinations[dayRouter.dayIndex].count-1{
                    des = destinations[dayRouter.dayIndex][index]
                    marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude:  des.cooridinate.latitude, longitude:  des.cooridinate.longitude    )
                    marker.title = des.name
                    marker.snippet = String(index)
                    marker.map = mapView
                    marker.icon = UIImage(named: "Marker")!.imageResized(to: CGSize(width: 30, height: 40))
                    marker.userData = des
                    locarr.append("\(des.cooridinate.latitude),\(des.cooridinate.longitude )")
            }
        }
         */
            
        for index in 0..._des.count-1{
            des = _des[index]
            marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: des.cooridinate.latitude, longitude:  des.cooridinate.longitude    )
            marker.title = des.name
            marker.snippet = String(index)
            marker.map = mapView
            marker.icon = UIImage(named: "Marker")!.imageResized(to: CGSize(width: 30, height: 40))
            marker.userData = des
            locarr.append("\(des.cooridinate.latitude),\(des.cooridinate.longitude )")
        }
        
        print("all locations")
        print(locarr)
        
        // MARK: Create URL
        var urlstr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(locarr[0])&destination=\(locarr[locarr.count-1])&mode=walking&key=AIzaSyAnU8CmfDD8S3X6xAYvlScSwvhrm2mht2A"
        if (locarr.count > 2) {
            urlstr = urlstr + "&waypoints="
            urlstr = urlstr + "via:\(locarr[1])"
            if (locarr.count > 3) {
                for i in 2...locarr.count-2 {
                    urlstr = urlstr + "|via:\(locarr[i])"
                }
            }
        }
        print("url string")
        print(urlstr)
        
        let url = URL(string: urlstr)
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let data = data {
                DispatchQueue.main.async {
                    let jsonData = JSON(data)
//                    print(jsonData)
                    let routes = jsonData["routes"].arrayValue
                    
                    for route in routes {
                        let disandtime = route["legs"].arrayValue[0].dictionary
                        distance = (disandtime?["distance"]?["value"].description)!
                        duration = (disandtime?["duration"]?["value"].description)!
                        let overview_polyline = route["overview_polyline"].dictionary
                        let points = overview_polyline?["points"]?.string
                        let path = GMSPath.init(fromEncodedPath: points ?? "")
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeColor = .systemOrange
                        polyline.strokeWidth = 8
                        polyline.map = mapView
                        
                    }

                }
                return
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()

        
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
     
        }
    func updateUIView(_ mapView: GMSMapView, context: Context) {    }
}
