//
//  addDesCommentView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/8.
//

import SwiftUI


// Get the Width and Height
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}


struct addDesCommentView: View {
    let heartSize: CGFloat = 20
    @State var currentRating: Int = 4
    @State private var commentText = "Make your comment here..."
    
    
    let destination :Destination = Destination(id: "ChIJZQD10CZawokRCuvDW1oLE-Y", img: "columbusPark", name: "Columbus Park", address: "Mulberry Street &, Baxter St, New York, NY 10013, USA", cooridinate: Coordinate(latitude: 40.71553530000001, longitude: -74.0000483), comments: [""], rating: 3)
    
    var body: some View {
        ZStack{
            // Map Background
            Image("addDesCommentbg").resizable().scaledToFill().frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            
            Button(action: {
                // TODO
            }) {
                Image(systemName: "arrow.left")
                    .padding()
                    .background(Color(red: 43/255, green: 185/255, blue: 222/255))
                    .foregroundColor(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 8)
            }.position(x: UIScreen.screenWidth/8, y: UIScreen.screenHeight/11)
            
            // White block
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .opacity(0.8)
                .padding(.bottom, 50)
                .padding(.top, UIScreen.screenHeight*0.42)
                .padding(.horizontal, 36)
            
            // Information block
            VStack(alignment: .leading, spacing: 15){
                HStack (alignment: .bottom, spacing: 30){
                    // Image
                    Image(self.destination.img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth*0.3, height: UIScreen.screenWidth*0.3).cornerRadius(15)
                    // Address
                    Text(self.destination.address)
                        .font(.system(size: 15, weight: .regular))
                        .frame(width: 120, height: UIScreen.screenWidth*0.15)
                }
                // Name
                Text(self.destination.name)
                    .font(.system(size: 36, weight: .regular))
                // Heart rating
                HStack(spacing: 12){
                    ForEach(0..<self.currentRating){ rate in
                        Image("heartfill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: heartSize, height: heartSize)
                            .onTapGesture {
                                self.currentRating = rate
                            }
                    }
                    ForEach(self.currentRating..<5){ rate in
                        Image("hearthollow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: heartSize, height: heartSize)
                            .onTapGesture {
                                self.currentRating = rate
                            }
                    }
                }
                // Comment editing
                TextEditor(text: $commentText)
                    .foregroundColor(self.commentText == "Make your comment here..." ? .gray : .primary)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.screenHeight/5)
                    .lineSpacing(1)
                    .onAppear {
                        // remove the placeholder text when keyboard appears
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                            withAnimation {
                                if self.commentText == "Make your comment here..." {
                                    self.commentText = ""
                                }
                            }
                        }
                        // put back the placeholder text if the user dismisses the keyboard without adding any text
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                            withAnimation {
                                if self.commentText == "" {
                                    self.commentText = "Make your comment here..."
                                }
                            }
                        }
                    }
                
                // Add to plan button
                Button(action: {
                    // TODO
                }) {
                    HStack {
                        Text("Add  to  plan")
                        .font(.system(size: 36, weight: .regular))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 30)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 43/255, green: 185/255, blue: 222/255))
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal, 72)
            .position(x: UIScreen.screenWidth/2, y:UIScreen.screenHeight*0.65)
            
        }
    }
}

struct addDesCommentView_Previews: PreviewProvider {
    static var previews: some View {
        addDesCommentView()
    }
}

