//
//  MenuView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/11.
//

import SwiftUI

struct DayBlock: View{
    @EnvironmentObject var dayRouter: DayRouter
    @Environment(\.colorScheme) var colorScheme
    let day: Int
    @Binding var showMenu: Bool

    
    var body: some View{
        Button(action: {
            self.dayRouter.dayIndex = day - 1
            self.showMenu = false
        }) {
            if colorScheme == .dark {
                Text("Day \(day)")
                    .font(.system(size: 22, weight: .regular))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 16)
                    .padding()
                    .background((self.dayRouter.dayIndex == day - 1) ? Color(UIColor.systemTeal) : Color(UIColor.tertiarySystemBackground))
                    .foregroundColor((self.dayRouter.dayIndex == day - 1) ? Color.white : Color(UIColor.systemTeal))
                    .opacity(0.9)
                    .cornerRadius(50)
            }
            else {
                Text("Day \(day)")
                    .font(.system(size: 22, weight: .regular))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 16)
                    .padding()
                    .background((self.dayRouter.dayIndex == day - 1) ? Color(UIColor.systemIndigo) : Color(UIColor.tertiarySystemBackground))
                    .foregroundColor((self.dayRouter.dayIndex == day - 1) ? Color.white : Color(UIColor.systemIndigo))
                    .opacity(0.9)
                    .cornerRadius(50)
            }
        }
    }
}

struct MenuButton: View {
    @Environment(\.colorScheme) var colorScheme
    let text: String
    var body: some View{
        HStack (spacing: 20){
            Text("\(text)")
                .font(.system(size: 22, weight: .regular))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 16)
        .padding()
        .foregroundColor(.white)
        .background(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
        .cornerRadius(50)
    }
}

struct AddDayButton: View {
    @EnvironmentObject var dayRouter: DayRouter
    @State var error = false
    let planId: String
    let destinations: [[Destination]]
    @Binding var showMenu: Bool

    var body: some View {
        Button(action: {
            self.addDay()
            self.dayRouter.dayIndex = self.destinations.count
            self.showMenu = false
        }) {
            HStack (spacing: 20){
                Text("Add a day")
                    .font(.system(size: 22, weight: .regular))
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 16)
            .padding()
            .foregroundColor(.gray)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray, lineWidth: 3)
            )
        }
    }
    func addDay() {
        API().addDay(planId: self.planId) { result in
            
            switch result {
            case .success:
                break
            case .failure:
                self.error = true
            }
        }
    }
}

struct MenuView: View {
    @EnvironmentObject var dayRouter: DayRouter
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorScheme
        
    @State var error = false
    let planId: String
    let users : [String]
    let destinations: [[Destination]]
    @Binding var showMenu: Bool
    @Binding var planIndex: Int
    @Binding var isLoginValid: Bool
    @State var planDict: [String: String]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // User icon
                ForEach(0..<users.count / 4 + 1) { i in
                    HStack{
                        ForEach(users[i*4..<min((i+1)*4, users.count)], id: \.self){ name in
                            utils().getUserImage(usernickname: name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                                .clipShape(Circle())
                        }
                    }
                }
                // Invite people
                NavigationLink(destination: InviteView(planId: self.planId)) {
                    HStack (spacing: 20) {
                        Image(systemName: "person.fill.badge.plus")
                            .font(.title)
                        Text("Invite friends")
                            .font(.system(size: 24, weight: .regular))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 20)
                    .padding()
                    .foregroundColor(.white)
                    .background(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                    .cornerRadius(50)
                }
                // Days
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(destinations.indices, id: \.self){ d in
                            DayBlock(day: d+1, showMenu: $showMenu)
                        }
                    }
                }
                VStack (spacing: 12){
                    // Add a day
                    AddDayButton(
                        planId: planId,
                        destinations: destinations,
                        showMenu: $showMenu
                    )
                    
                    Menu ("switch to other plan"){
                        ForEach(userData.currentUser.plans, id: \.self) { planId in
                            Button(action: {
                                self.planIndex = userData.currentUser.plans.firstIndex(of: planId)!
                                self.showMenu = false
                            }) {
                                Text("\(self.planDict[planId] ?? planId)")
                            }
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 16)
                    .padding()
                    .foregroundColor(.white)
                    .background(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                    .cornerRadius(50)
                    NavigationLink(destination: NewPlanView(showMenu: $showMenu, planIndex: $planIndex)) {
                        MenuButton(text: "create a new plan")
                    }
                    Button(action: {
                        self.isLoginValid = false
                    }, label: {
                        MenuButton(text: "Logout")
                    })
                }
                Spacer()
            }
            .padding(.top, 80)
            .padding(.horizontal, 36)
            .background(Color(UIColor.secondarySystemBackground).ignoresSafeArea())
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    func addDay() {
        API().addDay(planId: self.planId) { result in
            
            switch result {
            case .success:
                break
            case .failure:
                self.error = true
            }
        }
    }
    
    func fetchPlans(){
        let group = DispatchGroup()
        if (userData.currentUser.plans.count > 0) {
            for i in 0..<userData.currentUser.plans.count{
                group.enter()
                
                API().getPlan(planId: userData.currentUser.plans[i]) { result in
                    switch result {
                    case .success(let plan):
                        self.planDict[plan.id] = plan.name
                    case .failure:
                        self.error = true
                    }
                    group.leave()
                }
                
                group.wait()
            }
        }
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewWrapper()
//    }
//    struct PreviewWrapper: View {
//        @State var showMenu = true
//        @State var dayIndex = 0
//        @State var planIndex = 0
//
//        var body: some View{
//            MenuView(planId:"", users: ["Candy", "Bob", "Alice"], destinations: [[], []], showMenu: $showMenu, planIndex: $planIndex)
//        }
//    }
//}
