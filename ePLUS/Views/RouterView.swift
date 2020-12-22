


//
//  RouterView.swift
//  ePLUS
//
//  Created by kisaki on 2020/12/21.
//
import SwiftUI
import GoogleMaps
import SwiftyJSON

struct RouterView: UIViewRepresentable {
    @EnvironmentObject var dayRouter: DayRouter
    let destinations: [[Destination]]
    
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
        // MARK: Create URL
        var urlstr = "https://maps.googleapis.com/maps/api/directions/json?origin=\(locarr[0])&destination=\(locarr[locarr.count-1])&mode=walking&key=AIzaSyAnU8CmfDD8S3X6xAYvlScSwvhrm2mht2A"
        if locarr.count>2{
            urlstr.append("&waypoints=")
            for i in 1...locarr.count-2{
                urlstr.append("via:\(locarr[i])|")
            }
            urlstr = String(urlstr.dropLast( ))
            
        }
        let url =   URL(string:urlstr)
        print(locarr)
        let request = URLRequest(url: url!)
        print("")
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let data = data {
                DispatchQueue.main.async {
                    let jsonData = JSON(data)
                    print(jsonData)
                    let routes = jsonData["routes"].arrayValue
                    for route in routes {
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
