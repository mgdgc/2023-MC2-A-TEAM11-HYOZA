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
        
        NotificationManager.shared.requestAuthorization { granted in
            // 알림 모두 취소
            NotificationManager.shared.unregisterAll()
            // 일일 알림 재등록
            let dailyNoti = NotificationManager.shared.generateDailyNotification()
            let dailyTrig = NotificationManager.shared.generateDailyTrigger()
            NotificationManager.shared.register(dailyNoti, identifier: NotificationManager.Identifier.daily, trigger: dailyTrig)
            // 매달 알림 재등록
            let monthlyNoti = NotificationManager.shared.generatePublishNotification()
            let monthlyTrig = NotificationManager.shared.generateMonthlyTrigger(count: 12)
            NotificationManager.shared.register(monthlyNoti, identifier: NotificationManager.Identifier.monthly, trigger: monthlyTrig)
        }
    }
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                OnboardingView(showOnboardingView: $isFirstLaunch)
            } else {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(persistenceController)
            }
        }
    }
}
