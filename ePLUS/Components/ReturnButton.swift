//
//  ReturnButton.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/11.
//

import SwiftUI

struct ReturnButton: View {
    let action: () -> Void
    let size: Int
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Image(systemName: "arrow.left")
                .font(.system(size: CGFloat(self.size), weight: .bold))
                .padding(8)
                .background(Color(red: 43/255, green: 185/255, blue: 222/255))
                .foregroundColor(Color.white)
                .clipShape(Circle())
        }
    }
}

struct ReturnButton_Previews: PreviewProvider {
    static var previews: some View {
        ReturnButton(action: {}, size: 50)
    }
}
