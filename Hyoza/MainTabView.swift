//
//  MainTabView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/04.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selection: Int = 0
    @State var continuousDayCount: Int = 0
    @State var continueText: String? = nil
    @State var continueTextOpacity: Double = 1.0
    @State var tempTextStorage: String? = nil
    @State var isContinueIconAnimating: Bool = false
    @State var selectedQuestion: Question? = nil
    
    private let publisher = NotificationCenter.default.publisher(for: AttendanceManager.notificationAttendanceUpdate)
    
    var body: some View {
        TabView(selection: $selection) {
            TodayView(continuousDayCount: $continuousDayCount, continueText: $continueText, continueTextOpacity: $continueTextOpacity, tempTextStorage: $tempTextStorage, isContinueIconAnimating: $isContinueIconAnimating, selectedQuestion: $selectedQuestion)
                .tabItem {
                    Image(systemName: "heart.square.fill")
                    Text("Today")
                }
                .tag(0)
            
            ListView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("History")
                }
                .tag(1)
            
            PublishView()
                .tabItem {
                    Image(systemName: "text.book.closed.fill")
                    Text("Publish")
                }
                .tag(2)
        }
        .onAppear {
            selectedQuestion = PersistenceController.shared.selectedQuestion
            
            setAttendance()
            
            if !isContinueIconAnimating {
                self.isContinueIconAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    makeContinueIconSmall()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.isContinueIconAnimating = false
                    }
                }
            }
        }
        .onReceive(publisher) { output in
            setAttendance()
        }
    }
    
    private func makeContinueIconSmall() {
        self.continueTextOpacity = 0
        withAnimation(.easeInOut(duration: 0.7)) {
            self.continueText = nil
        }
    }
    
    private func setAttendance() {
        continuousDayCount = AttendanceManager().isAttending ? AttendanceManager().getAttendanceDay() : 0
        
        switch continuousDayCount {
        case 0:
            tempTextStorage = "작성을 시작해보세요!"
        case 1...:
            tempTextStorage = "연속 작성 \(continuousDayCount)일째 돌파!"
        default:
            tempTextStorage = "무언가 잘못됐어요 :("
        }
        continueText = tempTextStorage
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
