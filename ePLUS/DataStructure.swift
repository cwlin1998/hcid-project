//
//  data_structure.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/7.
//

import Foundation

struct Plan: Decodable, Identifiable {
    let id: String
    let img: String
    let destinations: [[String]]
    let users: [String]
}

struct Destination: Identifiable {
    let id: String
    let img: String
    let name: String
    let address: String
    let cooridinate: Coordinate
    let comments: [String]
    let rating: Int
}

struct Location: Decodable, Identifiable {
    let id: String
    let img: String
    let name: String
    let address: String
    let coordinate: Coordinate
}

struct Coordinate: Decodable {
    let latitude: Double
    let longitude: Double
}

struct EmptyJson: Decodable {}
