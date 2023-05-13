//
//  OrojiApp.swift
//  Oroji
//
//  Created by 최명근 on 2023/05/02.
//

import SwiftUI

@main
struct HyozaApp: App {
    
    @State private var isFirstLaunch: Bool
    
    init() {
        self.isFirstLaunch = UserDefaults.standard.object(forKey: UserDefaultsKey.isFirstLaunching.rawValue) == nil ? true : UserDefaults.standard.bool(forKey: UserDefaultsKey.isFirstLaunching.rawValue)
        
        NotificationManager.shared.requestAuthorization { granted in }
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                OnboardingView(showOnboardingView: $isFirstLaunch)
                    .onAppear {
                        UserDefaults.standard.set(false, forKey: UserDefaultsKey.isFirstLaunching.rawValue)
                    }
            } else {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
