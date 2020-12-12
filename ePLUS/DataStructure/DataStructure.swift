//
//  data_structure.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/7.
//

enum Page {
    case list
    case map
}

struct Plan: Codable, Identifiable {
    let id: String
    let img: String
    let destinations: [[String]]
    let users: [String]
}

struct Destination: Identifiable, Equatable {
    let id: String
    let img: String
    let name: String
    let address: String
    let cooridinate: Coordinate
    let comments: [String]
    let rating: Int
    
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Location: Codable, Identifiable {
    let id: String
    let img: String
    let name: String
    let address: String
    let coordinate: Coordinate
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

struct User: Codable {
    let account: String
    let password: String
    let nickname: String
    let plans: [String]
    let comments: [Comment]
}

struct Comment: Codable {
    let locationId: String
    let content: String
    let rating: Int
}

struct EmptyJson: Decodable {}
