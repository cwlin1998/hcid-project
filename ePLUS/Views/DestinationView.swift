//
//  DestinationView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/12.
//

import SwiftUI

struct DestinationView: View {
    let destination: Destination
    let users: [String]
        
    var body: some View {
        Text(destination.name)
    }
}

struct DestinationView_Previews: PreviewProvider {
    static var destination = Destination(
        id: "", img: "", name: "Test", address: "",
        cooridinate: Coordinate(latitude: 0.0, longitude: 0.0),
        comments: [:], rating: 2
    )
    static var previews: some View {
        DestinationView(destination: destination, users: [])
    }
}
