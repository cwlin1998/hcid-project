//
//  InviteView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/12.
//

import SwiftUI


struct InviteBlock: View {
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
                Text("@\(user.account)")
            }
            Spacer()
            Button(action: {
                // TODO invite user
            }) {
                Text("Invite")
                .font(.system(size: 20, weight: .regular))
                    .frame(width: 55, height: 8)
                .padding()
                .foregroundColor(.white)
                .background(Color(red: 43/255, green: 185/255, blue: 222/255))
                .cornerRadius(10)
            }
        }
    }
}


struct InviteView: View {
    @Environment(\.presentationMode) var presentationMode

    let inviteList: [User] = [
        User(account: "avocado", password: "", nickname: "zuccottiPark", plans: [], comments: []),
        User(account: "pizza", password: "", nickname: "Pizza", plans: [], comments: []),
        User(account: "rocket", password: "", nickname: "Rocket", plans: [], comments: [])
    ]
    
    var body: some View {
        VStack(spacing: 24){
            ZStack {
                HStack {
                    ReturnButton(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    Spacer()
                }
                Text("Invite").font(.title).fontWeight(.bold)
            }
            ScrollView{
                VStack (spacing: 12){
                    ForEach(inviteList, id: \.self.account) { person in
                        InviteBlock(user: person)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(UIColor.secondarySystemBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct InviteView_Previews: PreviewProvider {
    static var previews: some View {
        InviteView()
    }
}
