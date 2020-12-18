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
    func getPlanImage() -> Image{
        let num = Int.random(in: 0...5)
        let imgname = "randomBg\(num)"
        let uiImage = (UIImage(named: imgname) ?? UIImage(systemName: "photo")?.withTintColor(.purple, renderingMode: .alwaysTemplate))!
        return Image(uiImage: uiImage)
    }
    func getAllUsers()-> [String]{
        // here are all the users you create
        return ["guest", "a", "b", "c", "d"]
    }
}

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
