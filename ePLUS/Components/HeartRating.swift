//
//  HeartRating.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/11.
//

import SwiftUI

struct HeartRating: View {
    let heartSize: CGFloat = 20
    @Binding var rating: Int
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
                            updateRating(i+1)
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
    
    func updateRating(_ rating: Int) {
        self.rating = rating
        for i in 0..<self.rating {
            self.status[i] = "heartfill"
        }
        for i in self.rating..<5 {
            self.status[i] = "hearthollow"
        }
    }
}

struct HeartRating_Previews_Container: View {
    @State var rating: Int = 4
    
    var body: some View {
        HeartRating(rating: $rating)
    }
}

struct HeartRating_Previews: PreviewProvider {
    static var previews: some View {
        HeartRating_Previews_Container()
    }
}
