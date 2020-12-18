//
//  LoginView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/17.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var dayRouter: DayRouter
    @EnvironmentObject var userData: UserData

    @State private var account = ""
    @State private var password = ""
    
    @State private var isLoginValid: Bool = false
    @State private var shouldShowLoginAlert: Bool = false
    @State var userDict: [String: String] = [:]
    
    var body: some View {
        NavigationView() {
            VStack() {
                Text("Name")
                    .font(.largeTitle)
                    .shadow(radius: 10.0, x: 20, y: 10)
                Spacer()
                Image("zuccottiPark")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .padding(.bottom, 50)
                Spacer()
                VStack(alignment: .center, spacing: 20) {
                    TextField("Account", text: self.$account)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20.0)
                        .shadow(radius: 5.0, x: 10, y: 5)
                    
                    SecureField("Password", text: self.$password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20.0)
                        .shadow(radius: 5.0, x: 10, y: 5)
                    
                    NavigationLink(
                        destination: MainView(),
                        isActive: self.$isLoginValid,
                        label: {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color(red: 43/255, green: 185/255, blue: 222/255))
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                                .onTapGesture {
                                    print("tap login!")
                                    if verifyUser(account: self.account, password: self.password) {
                                        isLoginValid = true
                                    }
                                    if isLoginValid {
                                        userData.currentUser = User(account: self.account, password: self.password, nickname: self.account, plans: [], comments: [])
                                        self.isLoginValid = true //trigger NavigationLink
                                    } else {
                                        self.shouldShowLoginAlert = true //trigger Alert
                                    }
                                }
                    })
                }.padding([.leading, .trailing], 27.5)
                
                Spacer()
            }
            .onAppear(perform: fetchAllUser)
        }
        .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        .alert(isPresented: $shouldShowLoginAlert) {
            Alert(title: Text("Account/Password incorrect"))
        }
    }
    
    
    func fetchAllUser() {
        let group = DispatchGroup()
        
        // please revise all the users you create
        
        for user in utils().getAllUsers() {
            group.enter()
            API().getUser(userAccount: user) { result in
                switch result {
                case .success(let user):
                    self.userDict[user.account] = user.password
                case .failure:
                    print()
                }
                group.leave()
            }
            group.wait()
        }
        
        group.notify(queue: .main) {
            print("done!")
        }
    }
    
    
    func verifyUser(account: String, password: String) -> Bool {
        if self.userDict[account] == nil {
            return false
        }
        return self.userDict[account] == password
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
