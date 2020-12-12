//
//  RoundRectButton.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/11.
//

import SwiftUI

struct RoundedRectButton: View {
    let action: () -> Void
    let text: String
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Text(self.text)
            .font(.system(size: 36, weight: .regular))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 30)
            .padding()
            .foregroundColor(.white)
            .background(Color(red: 43/255, green: 185/255, blue: 222/255))
            .cornerRadius(15)
        }
    }
}

struct RoundedRectButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectButton(action: {}, text: "")
    }
}
