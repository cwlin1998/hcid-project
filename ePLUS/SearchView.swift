//
//  SearchView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/8.
//

import SwiftUI

struct SearchBlock: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var error = false
    let planId: String
    let location: Location
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text("\(location.name)")
            Text("\(location.address)")
        })
        .onTapGesture {
            self.addDestination(locationId: location.id)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func addDestination(locationId: String) {
        API().addDestination(planId: self.planId, locationId: locationId) { result in
            switch result {
            case .success:
                self.error = false
            case .failure:
                self.error = true
            }
        }
    }
}

struct SearchView: View {
    @State var error = false
    @State var locations: [Location]?
    
    let planId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            if (locations != nil) {
                ForEach(locations!) { location in
                    SearchBlock(planId: self.planId, location: location)
                }
            }
        })
        .onAppear(perform: getLocations)
    }
    
    func getLocations() {
        API().getLocations() { result in
            switch result {
            case .success(let locations):
                self.locations = locations
            case .failure:
                self.error = true
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    @State var navBarHidden = true
    static var previews: some View {
        SearchView(planId: "")
    }
}
