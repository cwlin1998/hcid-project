//
//  MenuView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/11.
//

import SwiftUI

struct DayBlock: View{
    let day: Int
    var body: some View{
        HStack (spacing: 20){
            Text("Day \(day)")
                .font(.system(size: 22, weight: .regular))
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 16)
        .padding()
        .background(Color(UIColor.tertiarySystemBackground))
        .foregroundColor(Color(UIColor.systemIndigo))
        .opacity(0.8)
        .cornerRadius(50)
    }
    
}

struct MenuView: View {
    let planId: String = ""
    let users : [String] = ["zuccottiPark", "Amy", "Bob", "Candy"]
    let destinations: [[Destination]] = [[],[]]
    @State var showMenu = false
    
    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)
            .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                // User icon
                ForEach(0..<users.count / 4 + 1) { i in
                    HStack{
                        ForEach(users[i*4..<min((i+1)*4, users.count)], id: \.self){ name in
                            utils().getUserImage(usernickname: name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color(UIColor.systemIndigo))
                                .clipShape(Circle())
                        }
                    }
                }
                // Invite people
                Button(action: {
                    // TODO: get to invite view
                }) {
                    HStack (spacing: 20){
                        Image(systemName: "person.fill.badge.plus")
                            .font(.title)
                        Text("Invite people")
                            .font(.system(size: 24, weight: .regular))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 24)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(UIColor.systemIndigo))
                    .cornerRadius(50)
                }
                // Days
                ForEach(0..<destinations.count){ d in
                    DayBlock(day: d+1)
                }
                // Add a day
                Button(action: {
                    // TODO: get to add a day page
                }) {
                    HStack (spacing: 20){
                        Text("Add a day")
                            .font(.system(size: 22, weight: .regular))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 16)
                    .padding()
                    .foregroundColor(.gray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.gray, lineWidth: 3)
                    )
                }
                Spacer()
            }
            .padding(.top, 80)
            .padding(.horizontal, 8)
        }
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
