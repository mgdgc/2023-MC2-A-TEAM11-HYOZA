//
//  AttendanceManager.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/11.
//

import Foundation

class AttendanceManager {
    
    static let udLastAttended = "last_attended"
    static let udFirstAttended = "first_attended"
    
    func getFirstAttendedDate() -> Date? {
        return UserDefaults.standard.object(forKey: AttendanceManager.udFirstAttended) as? Date
    }
    
    func getLastAttendedDate() -> Date? {
        return UserDefaults.standard.object(forKey: AttendanceManager.udLastAttended) as? Date
    }
    
    /// 저장된 마지막 출석 날짜를 기준으로 출석 일수를 반환합니다. 연속 출석인지의 여부는 고려되지 않습니다.
    func getAttendanceDay() -> Int {
        guard let lastDate = getLastAttendedDate(), let firstDate = getFirstAttendedDate() else {
            return 0
        }
        
        let diff = Calendar.current.numberOfDaysBetween(lastDate, and: firstDate)
        return diff + 1
    }
    
    /// 마지막으로 출석한 날짜와 오늘의 날짜 차이가 이틀 이상이면 false를 반환합니다.
    var isAttending: Bool {
        guard let lastDate = getLastAttendedDate() else {
            return false
        }
        let diff = Calendar.current.numberOfDaysBetween(Date(), and: lastDate)
        return diff < 2
    }
    
    /// 답변했을 때 호출합니다. 연속 출석인 경우 날짜가 업데이트되며, 연속 출석이 깨졌다면 이 코드에서 초기화됩니다.
    func updateAttendance() -> Bool {
        guard let lastDate = getLastAttendedDate() else {
            UserDefaults.standard.set(Date(), forKey: AttendanceManager.udFirstAttended)
            UserDefaults.standard.set(Date(), forKey: AttendanceManager.udLastAttended)
            return true
        }
        
        let diff = Calendar.current.numberOfDaysBetween(Date(), and: lastDate)
        
        if diff <= 0 {
            return true
            
        } else if diff <= 1 {
            UserDefaults.standard.set(Date(), forKey: AttendanceManager.udLastAttended)
            
            return true
            
        } else {
            UserDefaults.standard.removeObject(forKey: AttendanceManager.udFirstAttended)
            UserDefaults.standard.removeObject(forKey: AttendanceManager.udLastAttended)
            
            return false
        }
    }
    
}
