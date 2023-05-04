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
            ContentView()
                .id(0)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
