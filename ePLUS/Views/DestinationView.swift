//
//  DestinationView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/12.
//

import SwiftUI

struct CommentBlock: View{
    var user: String
    var content: String
    @State var rating: Float
    
    var body: some View{
        VStack(alignment: .leading, spacing: 8){
            Text(self.content)
            Spacer()
            HStack (spacing: 12){
                utils().getUserImage(usernickname: user)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(UIColor.systemIndigo))
                    .clipShape(Circle())
                VStack (alignment: .leading){
                    Text(user)
                        .bold()
                        .foregroundColor(Color(UIColor.systemIndigo))
                    HeartRating(rating: self.$rating).disabled(true)
                }
                Spacer()
            }
        }
        .padding(20)
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 160)
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(10)
    }
    
}

struct DestinationView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    @State var loading = false
    let destination: Destination
    let users: [String]
    @State var usercommentDict = [String: Comment]()
    var body: some View {
        VStack{
            if loading {
                LoadingView()
            }
            ZStack(alignment: .top){
                Color(UIColor.secondarySystemBackground).ignoresSafeArea()
                
                ScrollView{
                    VStack (spacing: 24){
                        GooglePlaceImage(url: self.destination.img, width: Int(UIScreen.main.bounds.size.width*0.8), height: Int(UIScreen.main.bounds.size.width*0.45), cornerRadius: 10)
                        Text(self.destination.address)
                        ForEach(usercommentDict.keys.sorted(), id: \.self) {key in
                            CommentBlock(user: key, content: usercommentDict[key]!.content, rating: Float(usercommentDict[key]!.rating))
                        }
                    }
                    .padding(.horizontal, 36)
                    .padding(.top, 130)
                }
                
                ZStack{
                    Image("desNavigateBar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*0.32)
                    HStack {
                        ReturnButton(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, size: 35)
                        Spacer()
                    }
                    HStack{
                        Text(self.destination.name).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                    }
                }
            }
        }
        .onAppear(perform: fetchData)
        .navigationBarHidden(true)
        .ignoresSafeArea(.all)
    }
    
    func fetchData() {
        let group = DispatchGroup()
        
        var usercommentDict = [String: Comment]()
        
        for userAccount in self.users {
            print(userAccount)
            group.enter()
            API().getComment(userAccount: userAccount, locationId: self.destination.id) { result in
                switch result {
                case .success(let comment):
                    usercommentDict[userAccount] = comment
                case .failure:
//                    usercommentDict[userAccount] = Comment(locationId: self.destination.id, content: "", rating: 0)
                    if userData.currentUser.account == userAccount{
                        usercommentDict[userAccount] = Comment(locationId: self.destination.id, content: "you haven't make comment yet!", rating: 0)
                    }
                }
                group.leave()
            }
            group.wait()
        }
        
        
        group.notify(queue: .main) {
            print(usercommentDict as Any)
            self.usercommentDict = usercommentDict
            self.loading = false
        }
        
    }
}


struct DestinationView_Previews: PreviewProvider {
    static var destination = Destination(
        id: "", img: "", name: "Zuccotti Park", address: "",
        cooridinate: Coordinate(latitude: 0.0, longitude: 0.0),
        comments: [:], rating: 2
    )
    static var previews: some View {
//        DestinationView(destination: destination, users: ["guest", "a", "b", "c"])
        CommentBlock(user: "guest", content: "hi~~~", rating: 5)
    }
}
