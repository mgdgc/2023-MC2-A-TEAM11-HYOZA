//
//  MainTabView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/04.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            TodayView()
                .tabItem {
                    Image(systemName: "heart.square.fill")
                    Text("Today")
                }
                .tag(0)
            
            ListView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Today")
                }
                .tag(1)
            
            PublishView()
                .tabItem {
                    Image(systemName: "text.book.closed.fill")
                    Text("Today")
                }
                .tag(2)
        }
        .onAppear {
            print(NSHomeDirectory())
        }
//        #warning("debugging을 위한 onAppear 함수")
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
