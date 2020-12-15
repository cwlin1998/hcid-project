//
//  CityImageStructure.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/13.
//

import Foundation

struct CityImgSearchResponse: Codable {
    let photos: [Photo]
    struct Photo: Codable {
        let image: Image
        struct Image: Codable {
            let mobile, web: String
        }
    }
}
