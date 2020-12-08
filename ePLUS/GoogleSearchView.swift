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

struct PlacePicker: UIViewControllerRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentationMode
    @Binding var placeId: String
//    @Binding var address: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlacePicker>) -> GMSAutocompleteViewController {

        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator

        GMSPlacesClient.provideAPIKey("AIzaSyBP-OM2AulCwjnQV8IN72HdH-w12umJpxQ")

        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue) |
                UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue)
        )
        autocompleteController.placeFields = fields

//        let filter = GMSAutocompleteFilter()
//        filter.country = "US"
//        autocompleteController.autocompleteFilter = filter
        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: UIViewControllerRepresentableContext<PlacePicker>) {
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {

        var parent: PlacePicker

        init(_ parent: PlacePicker) {
            self.parent = parent
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            DispatchQueue.main.async {
//                print(place.name!)
//                print(place.formattedAddress!)
//                print(place.placeID!)
                self.parent.placeId = place.placeID!
                self.parent.viewRouter.currentPage = .addDestination
//                print(place.description.description as Any)
//                self.parent.address =  place.name!
//                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//            parent.presentationMode.wrappedValue.dismiss()
            parent.viewRouter.currentPage = .list
        }

    }
}

struct GoogleSearchView: View {
    @Binding var placeId: String

    var body: some View {
        PlacePicker(placeId: self.$placeId)
    }
}

struct GoogleSearchViewPreviewContainer: View {
    @State var placeId: String = ""

    var body: some View {
        PlacePicker(placeId: self.$placeId)
    }
}

struct GoogleSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSearchViewPreviewContainer()
    }
}
