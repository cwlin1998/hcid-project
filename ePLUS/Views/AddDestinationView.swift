//
//  GoogleSearchView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/8.
//

import SwiftUI
import UIKit
import GooglePlaces
import Foundation

struct AutoCompleteView: UIViewControllerRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var placeId: String
    @Binding var searching: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<AutoCompleteView>) -> UINavigationController {

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator

        GMSPlacesClient.provideAPIKey("\(GooglePlaceAPI.key)")

        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue) |
                UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue)
        )
        autocompleteController.placeFields = fields
        autocompleteController.tableCellBackgroundColor = UIColor.secondarySystemBackground
        
        // filter
        // let filter = GMSAutocompleteFilter()
        // filter.country = "US"
        // autocompleteController.autocompleteFilter = filter
        return UINavigationController(rootViewController: autocompleteController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<AutoCompleteView>) {
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {

        var parent: AutoCompleteView

        init(_ parent: AutoCompleteView) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            DispatchQueue.main.async {
                self.parent.placeId = place.placeID!
                self.parent.searching = false
                // print(place.description.description as Any)
            }
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}

struct AddDestinationView: View {
    @EnvironmentObject var userData: UserData
    
    let planId: String
    let dayIndex: Int
    @State var placeId: String = ""
    @State var searching: Bool = true

    var body: some View {
        VStack {
            if (searching) {
                AutoCompleteView(placeId: $placeId, searching: $searching).ignoresSafeArea(edges: .all)
            } else {
                AddDesCommentView(planId: planId, dayIndex: dayIndex, placeId: placeId, searching: $searching)
            }
        }
        .navigationBarHidden(true)
    }
}

struct AddDestination_Previews: PreviewProvider {
    static var previews: some View {
        AddDestinationView(planId: "", dayIndex: 0)
            .environmentObject(UserData())
    }
}
