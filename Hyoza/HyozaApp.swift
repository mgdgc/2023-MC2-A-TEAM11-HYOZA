//
//  OrojiApp.swift
//  Oroji
//
//  Created by 최명근 on 2023/05/02.
//

import SwiftUI

@main
struct HyozaApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
