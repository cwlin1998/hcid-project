//
//  ListView.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/11/30.
//

import SwiftUI

struct ListBlock: View {
    let destination: Destination
    
    var body: some View {
        let heartSize: CGFloat = 20
        HStack(alignment: .center, spacing: 20, content: {
            Image(self.destination.img)
                .resizable()
                .cornerRadius(10)
                .frame(width: 60, height: 60)
            VStack(alignment: .leading, spacing: 10, content: {
                Text("\(self.destination.name)").bold()
                HStack(spacing: 12){
                    ForEach(0..<self.destination.rating){ _ in
                        Image("heartfill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: heartSize, height: heartSize)
                    }
                    ForEach(self.destination.rating..<5){ _ in
                        Image("hearthollow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: heartSize, height: heartSize)
                    }
                }
            })
        })
    }
}

struct ListView: View {
    @State var error = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    let name: String
    let destinations: [[Destination]]
    let users: [String]
    let planId: String

    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 30, content: {
                ForEach(destinations[0]) { des in
                    ListBlock(destination: des)
                }
                Button(action: {
                    viewRouter.currentPage = .map
                }, label: {
                    Text("Show in map")
                })
                Button(action: {
                    viewRouter.currentPage = .search
                }, label: {
                    Text("Add a destination")
                })
//                NavigationLink(destination: SearchView(planId: planId)) {
//                    Text("Add a destination")
//                }
            })
        }
        .navigationBarTitle(Text("\(name)"))
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper().environmentObject(ViewRouter())
    }
    struct PreviewWrapper: View {
        
        @State var destinations: [[Destination]] = [
            [],
            []
        ]
        @State var users: [String] = [
            "guest"
        ]
        
        var body: some View{
            ListView(name: "", destinations: destinations, users: users, planId: "")
        }
    }
}
