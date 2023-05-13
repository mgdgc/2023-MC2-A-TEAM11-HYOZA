//
//  NotificationManager.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/08.
//

import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() { }
    
    // MARK: - 알림 권한 요청
    func requestAuthorization(options: UNAuthorizationOptions = [.alert, .badge, .sound], completion: @escaping (_ granted: Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(#function, error)
            }
            
            completion(success)
        }
    }
    
    // MARK: - 매일 알림
    func generateDailyNotification() -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = "오늘의 질문이 도착했어요"
        notification.body = "원고를 작성할 시간이에요 ✍️"
        
        return notification
    }
    
    // MARK: 출판 알림
    func generatePublishNotification() -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = "월간 출판 알림"
        notification.body = "5월의 자서전을 출판해보세요 📕"
        
        return notification
    }
    
    // MARK: - 매일 알림 Trigger
    func generateDailyTrigger(hour: Int = 18, minute: Int = 0) -> UNCalendarNotificationTrigger {
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        return trigger
    }
    
    // MARK: 한달 알림 Trigger
    func generateMonthlyTrigger(since: Date = Date(), hour: Int = 18, minute: Int = 0, count: Int) -> UNCalendarNotificationTrigger {
        var date = DateComponents()
        date.day = since.day <= 1 ? 30 : since.day - 1
        date.hour = hour
        date.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        return trigger
    }
    
    // MARK: - 등록된 알림 확인
    func getRegisteredNotifications(result: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            result(requests)
        }
    }
    
    // MARK: - 알림 등록
    func register(_ notification: UNMutableNotificationContent, identifier: NotificationManager.Identifier, trigger: UNNotificationTrigger) {
        // 알림 request
        let request = UNNotificationRequest(identifier: identifier.rawValue, content: notification, trigger: trigger)
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // 알림 등록 불가 오류 처리
                print(#function, error)
            }
        }
    }
    
    // MARK: - 알림 취소
    func unregister(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // MARK: 알림 전체 취소
    func unregisterAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Notification Identifier
    enum Identifier: String {
        case daily = "hyoza_daily"
        case monthly = "hyoza_monthly"
    }
}
