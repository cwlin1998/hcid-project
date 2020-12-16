//
//  HeartRating.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/11.
//

import SwiftUI

struct HeartRating: View {
    let heartSize: CGFloat = 20
    @Binding var rating: Float
    @State var status: [String] = ["hearthollow", "hearthollow", "hearthollow", "hearthollow", "hearthollow"]
    @State var changable: Bool = false

    var body: some View {
        // Heart rating
        HStack(spacing: 12){
            ForEach(self.status.indices) { i in
                Image(self.status[i])
                    .resizable()
                    .scaledToFit()
                    .frame(width: heartSize, height: heartSize)
                    .onTapGesture {
                        if (changable) {
                            updateRating(Float(i+1))
                        }
                    }
            }
        }.onAppear(perform: {
            updateRating(self.rating)
            if (self.rating == 0) {
                self.changable = true
            }
        })
    }
    
    func updateRating(_ rating: Float) {
        self.rating = rating
        for i in 0..<Int(self.rating) {
            self.status[i] = "heartfill"
        }
        for i in Int(self.rating)..<5 {
            self.status[i] = "hearthollow"
        }
    }
}

struct HeartRating_Previews_Container: View {
    @State var rating: Float = 4.0
    
    var body: some View {
        HeartRating(rating: $rating)
    }
}

struct HeartRating_Previews: PreviewProvider {
    static var previews: some View {
        HeartRating_Previews_Container()
    }
}
