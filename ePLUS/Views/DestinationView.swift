//
//  DestinationView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/12.
//

import SwiftUI


struct EditCommentBlock: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorScheme
    let destination: Destination
    @State var commentText: String
    @State var rating: Float
    @Binding var showEditComment: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
                .opacity(0.9)
            VStack {
                TextArea(commentText, text: self.$commentText, height: .infinity)
                Spacer()
                HeartRating(rating: self.$rating).disabled(false)
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.showEditComment.toggle()
                        }
                    }) {
                        Text("CANCEL").bold()
                    }
                    Spacer()
                    Button(action: {
                        self.addComment()
                        withAnimation {
                            self.showEditComment.toggle()
                        }
                    }) {
                        Text("DONE").bold()
                    }
                    Spacer()
                }
            }
            .padding(15)
        }
        .frame(width: UIScreen.screenWidth/3*2, height: UIScreen.screenHeight/3)
    }
    
    func addComment() {
        
        let comment = Comment(locationId: self.destination.id, content: self.commentText, rating: Int(self.rating))
        
        API().addComment(userAccount: userData.currentUser.account, comment: comment) { result in
            switch result {
            case .success:
                print("add comment success")
                break
            case .failure:
                print("add comment failure")
                break
            }
        }
    }
}


struct CommentBlock: View{
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorScheme
    
    var user: String
    var content: String
    let rating: Float
    @Binding var showEditComment: Bool
    
    var body: some View{
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(self.content)
                Spacer()
                Button(action: {
                    withAnimation {
                        self.showEditComment.toggle()
                    }
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: CGFloat(25), weight: .bold))
                        .foregroundColor(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                        .opacity(self.user == userData.currentUser.account ? 1 : 0)
                }.disabled(self.user == userData.currentUser.account ? false : true)
            }
            HStack (spacing: 12) {
                utils().getUserImage(usernickname: user)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                    .clipShape(Circle())
                VStack (alignment: .leading){
                    Text(user)
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                    DisabledHeartRating(rating: self.rating).disabled(true)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 160)
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(10)
    }
    
}

struct DestinationView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    @State var loading = true
    let destination: Destination
    let users: [String]
    @State var usercommentDict = [String: Comment]()
    @State var showEditComment: Bool = false
    var body: some View {
        VStack{
            if loading {
                LoadingView()
            }
            else {
                ZStack(alignment: .top) {
                    Color(UIColor.secondarySystemBackground).ignoresSafeArea()
                    
                    if usercommentDict.count != 0 {
                        ScrollView {
                            VStack (spacing: 24) {
                                // Destination Image
                                GooglePlaceImage(url: self.destination.img, width: Int(UIScreen.main.bounds.size.width*0.8), height: Int(UIScreen.main.bounds.size.width*0.45), cornerRadius: 10)
                                // Address
                                Text(self.destination.address)
                                // the user's comment
                                CommentBlock(user: userData.currentUser.account, content: self.usercommentDict[userData.currentUser.account]!.content, rating: Float(self.usercommentDict[userData.currentUser.account]!.rating), showEditComment: self.$showEditComment)
                                // others' comment
                                ForEach(usercommentDict.keys.sorted(), id: \.self) {key in
                                    if key != userData.currentUser.account {
                                        CommentBlock(user: key, content: usercommentDict[key]!.content, rating: Float(usercommentDict[key]!.rating), showEditComment: self.$showEditComment)
                                    }
                                }
                            }
                            .padding(.horizontal, 36)
                            .padding(.top, 130)
                        }
                    }
                    
                    // Navigation Bar
                    ZStack {
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
                        HStack {
                            Text(self.destination.name).font(.title).bold()
                        }
                    }
                    
                    // Edit comment or not
                    if showEditComment {
                        EditCommentBlock(destination: self.destination, commentText: usercommentDict[userData.currentUser.account]!.content, rating: Float(usercommentDict[userData.currentUser.account]!.rating), showEditComment: self.$showEditComment)
                            .offset(y: UIScreen.screenWidth/2.5)
                    }
                }
            }
        }
        .onAppear(perform: self.fetchData)
        .onReceive(self.timer) { _ in
            DispatchQueue.global(qos: .background).async {
                self.fetchData()
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.all)
    }
    
    func fetchData() {
        let group = DispatchGroup()
        
        var usercommentDict = [String: Comment]()
        
        for userAccount in self.users {
            group.enter()
            API().getComment(userAccount: userAccount, locationId: self.destination.id) { result in
                switch result {
                case .success(let comment):
                    usercommentDict[userAccount] = comment
                case .failure:
                    if userData.currentUser.account == userAccount{
                        usercommentDict[userAccount] = Comment(locationId: self.destination.id, content: "Make your comment here...", rating: 0)
                    }
                }
                group.leave()
            }
            group.wait()
        }
        
        group.notify(queue: .main) {
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
        CommentBlock(user: "guest", content: "hi~~~", rating: 5, showEditComment: .constant(false))
    }
}
