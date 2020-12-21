//
//  InviteView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/12.
//

import SwiftUI


struct InviteBlock: View {
    
    @State var error: Bool = false
    
    let planId: String
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            utils().getUserImage(usernickname: user.nickname)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(Color.gray)
                .clipShape(Circle())
            VStack (alignment: .leading){
                Text(user.nickname)
                    .font(.system(size: 24, weight: .bold))
                    .lineLimit(1)
                HStack {
                    Text("@\(user.account)")
                    Spacer()
                    Button(action: {
                        self.addUser2Plan()
                    }) {
                        Text("Invite")
                            .font(.system(size: 20, weight: .regular))
                            .frame(width: 55, height: 24)
                            .padding(.horizontal, 8)
                            .foregroundColor(.white)
                            .background(Color(red: 43/255, green: 185/255, blue: 222/255))
                            .cornerRadius(10)
                    }
                }
            }
            Spacer()
        }
    }
    
    func addUser2Plan() {
        API().addUser2Plan(planId: self.planId, userAccount: self.user.account) { result in
            switch result {
            case .success:
                self.error = false
            case .failure:
                self.error = true
            }
        }
    }
    
}


struct InviteView: View {
    @Environment(\.presentationMode) var presentationMode
        
    @State var loading = false
    @State var error = false
    let planId: String
    @State var query = ""
    @State var inviteList: [User]?
        
    var body: some View {
        VStack(spacing: 24){
            if (loading) {
                Text("loading...")
            }
            ZStack {
                HStack {
                    ReturnButton(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, size: 30)
                    Spacer()
                }
                Text("Invite").font(.title).fontWeight(.bold)
            }
            TextField("search", text: $query)
                .autocapitalization(.none)
                .onChange(of: query) { _ in
                    self.fetchInviteList(query: query)
                }
            ScrollView{
                VStack (spacing: 12){
                    if (loading) {
                        LoadingView()
                    }
                    if (inviteList != nil) {
                        ForEach(inviteList!, id: \.self.account) { user in
                            InviteBlock(planId: self.planId, user: user)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(UIColor.secondarySystemBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    func fetchInviteList(query: String) {
        self.loading = true

        let group = DispatchGroup()

        var inviteList: [User] = []
        if (query != "") {
            group.enter()
            API().getUsers(query: query) { result in
                switch result {
                case .success(let users):
                    for user in users {
                        if (!user.plans.contains(self.planId)) {
                            inviteList.append(user)
                        }
                    }
                case .failure:
                    break
                }
                group.leave()
            }
            group.wait()
        }
        
        group.notify(queue: .main) {
            if (inviteList != self.inviteList) {
                self.inviteList = inviteList
            }
            self.loading = false
        }
    }
    
}
/*
struct InviteView_Previews: PreviewProvider {
    static var previews: some View {
        InviteView(planId: "", inviteList: [User(account: "avocado", password: "", nickname: "zuccottiPark", plans: [], comments: [:]),
                                            User(account: "pizza", password: "", nickname: "Pizza", plans: [], comments: [:]),
                                            User(account: "rocket", password: "", nickname: "Rocket", plans: [], comments: [:])
        ]
        )
    }
}
*/
