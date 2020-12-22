//
//  data_structure.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/7.
//

enum Page {
    case list
    case map
    case route
}

struct Plan: Codable, Identifiable {
    let id: String
    let img: String
    let name: String
    let destinations: [[String]]
    let users: [String]
}

struct Destination: Identifiable, Equatable {
    let id: String
    let img: String
    let name: String
    let address: String
    let cooridinate: Coordinate
    let comments: [String: String]
    let rating: Float
    
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        return (lhs.id == rhs.id && lhs.comments == rhs.comments && lhs.rating == rhs.rating)
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

struct User: Codable, Equatable {
    let account: String
    let password: String
    let nickname: String
    let plans: [String]
    let comments: [String: Comment]
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.account == rhs.account
    }
}

struct Comment: Codable {
    let locationId: String
    let content: String
    let rating: Int
}

struct EmptyJson: Decodable {}
