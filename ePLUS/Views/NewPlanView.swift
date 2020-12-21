//
//  NewPlanView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/12.
//

import SwiftUI

struct CustomStepper : View {
    @Binding var value: Int
    var textColor: Color
    var step = 1
    var valueText: Binding<String> {
        .init(get: {
            "\(self.value)"
        }, set: {
            self.value = Int($0) ?? self.value
        })
    }
    var body: some View {
        HStack (spacing: 12){
            Button(action: {
                if self.value > 1 {
                    self.value -= self.step
                    self.feedback()
                }
            }, label: {
                Image(systemName: "minus.square")
                    .font(.system(size: CGFloat(25), weight: .bold))
                    .foregroundColor(value > 1 ? textColor : Color.gray)
            })
            
            TextField(" \(value)", text: valueText)
                .font(.title)
                .foregroundColor(textColor)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(width: 50, height: 50)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                        withAnimation {
                            self.value = self.value > 99 ? 99 : self.value
                            self.value = self.value < 1 ? 1 : self.value
                        }
                    }
                }
            Button(action: {
                if self.value < 99 {
                    self.value += self.step
                    self.feedback()
                }
            }, label: {
                Image(systemName: "plus.square")
                    .font(.system(size: CGFloat(25), weight: .bold))
                    .foregroundColor(value < 99 ? textColor : Color.gray)
            })
        }
    }
    func feedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

struct CreatePlanButton: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorScheme
    
    let planName: String
    @State var error = false
    @Binding var showMenu: Bool
    @Binding var planIndex: Int
    
    var body : some View{
        Button(action: {
            self.addPlan()
            self.planIndex = userData.currentUser.plans.count
            self.showMenu = false
        }) {
            Text("Create")
                .font(.system(size: 28, weight: .regular))
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 20)
                .padding()
                .foregroundColor(.white)
                .background(colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo))
                .cornerRadius(15)
                .navigationBarHidden(true)
        }
    }
    
    func addPlan() {
        API().addPlan(userAccount: userData.currentUser.account, planName: planName) { result in
            switch result {
            case .success:
                break
            case .failure:
                self.error = true
            }
        }
    }
    
}

struct NewPlanView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userData: UserData
    @Environment(\.colorScheme) var colorScheme
    
    @State var error = false
    var havePlan = true
    @State var nameText: String = ""
    @State var day: Int = 3
    @Binding var showMenu: Bool
    @Binding var planIndex: Int
    
    var dayText: Binding<String> {
        .init(get: {
            "\(self.day)"
        }, set: {
            self.day = Int($0) ?? self.day
        })
    }
    
    var body: some View {
        VStack(spacing: 24){
            ZStack {
                HStack {
                    ReturnButton(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, size: 20)
                    Spacer()
                }
                HStack{
                    if havePlan { Spacer() }
                    Text("Create New Plan").font(.system(size: 24, weight: .bold))
                }
            }
            VStack(spacing: 20) {
                // Name
                HStack (alignment: .bottom){
                    Text("Name:").font(.title).fontWeight(.bold)
                    TextField("Plan name", text: self.$nameText)
                        .font(.system(size: 28, weight: .regular))
                        .frame(minWidth: 0, maxWidth: .infinity)
                    Spacer()
                }.frame(height: 50)
                
                // Days
                ZStack {
                    HStack {
                        Text("Days:").font(.title).fontWeight(.bold)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        CustomStepper(value: self.$day, textColor: colorScheme == .dark ? Color(UIColor.systemTeal): Color(UIColor.systemIndigo), step: Int(1))
                    }
                }.frame(height: 50)
                
                // Invite people
                HStack (spacing: 20) {
                    Image(systemName: "person.fill.badge.plus")
                        .font(.title)
                    Text("Invite people")
                        .font(.system(size: 24, weight: .regular))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 20)
                .padding()
                .foregroundColor(.white)
                .background(Color(UIColor.systemIndigo))
                .cornerRadius(50)
                Spacer()
                
                // Button
                HStack{
                    Button(action:{
                        self.presentationMode.wrappedValue.dismiss()
                        // TODO: action sheet
                    }) {
                        Text("Cancel")
                            .font(.system(size: 28, weight: .regular))
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 20)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(.lightGray))
                            .cornerRadius(15)
                    }
                    
                    CreatePlanButton(planName: nameText, showMenu: $showMenu, planIndex: $planIndex)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(UIColor.secondarySystemBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
}

/*
struct NewPlanView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlanView(showMenu: .constant(false))
    }
}
 */
