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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var loading = true
    @State var error = false
    let planId: String
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
            ScrollView{
                VStack (spacing: 12){
                    if (inviteList != nil) {
                        ForEach(inviteList!, id: \.self.account) { person in
                            InviteBlock(planId: self.planId, user: person)
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear(perform: fetchInviteList)
        .onReceive(timer) { _ in
            self.fetchInviteList()
        }
        .padding(.horizontal, 20)
        .background(Color(UIColor.secondarySystemBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    
    func fetchInviteList() {
        let group = DispatchGroup()

        var inviteList: [User] = []
        // please revise all the users you create
        for user in utils().getAllUsers() {
            group.enter()
            API().getUser(userAccount: user) { result in
                switch result {
                case .success(let user):
                    if !user.plans.contains(self.planId) {
                        inviteList.append(user)
                    }
                case .failure:
                    print("fetch user in invite failure")
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

struct InviteView_Previews: PreviewProvider {
    static var previews: some View {
        InviteView(planId: "", inviteList: [User(account: "avocado", password: "", nickname: "zuccottiPark", plans: [], comments: []),
                                                 User(account: "pizza", password: "", nickname: "Pizza", plans: [], comments: []),
                                                 User(account: "rocket", password: "", nickname: "Rocket", plans: [], comments: [])
        ]
        )
    }
}
