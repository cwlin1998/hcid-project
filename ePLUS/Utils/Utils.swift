//
//  Utils.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/11.
//

import SwiftUI

// Get the Width and Height
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct utils{
    func getUserImage(usernickname: String) -> Image {
        let firstcharacter: String = String(usernickname.prefix(1)).lowercased()
        let uiImage = (UIImage(named: usernickname) ?? UIImage(systemName: "\(firstcharacter).circle.fill")?.withTintColor(.purple, renderingMode: .alwaysTemplate))!
        return Image(uiImage: uiImage)
    }
}
