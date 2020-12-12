//
//  NewPlanView.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/12.
//

import SwiftUI

struct NewPlanView: View {
    @State private var day = 3
    static let formatter = NumberFormatter()
    var binding: Binding<String> {
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
                        // TODO
                    })
                    Spacer()
                }
                Text("Create New Plan").font(.title).fontWeight(.bold)
            }
            VStack{
                HStack {
                    TextField("", text: binding)
                        Stepper("", onIncrement: {
                            self.day += 1
                        }, onDecrement: {
                            self.day -= (self.day > 0 ? 1 : 0)
                    }).keyboardType(.decimalPad)
//                    Text("Days: \(day)").font(.title).fontWeight(.bold)
                    //                   Spacer()
//
//                    Stepper("", onIncrement: {
//                            self.day += 1
//                        }, onDecrement: {
//                            self.day -= (self.day > 0 ? 1 : 0)
//                        }
//                    )
//                    .cornerRadius(8)
                }
                
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct NewPlanView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlanView()
    }
}
