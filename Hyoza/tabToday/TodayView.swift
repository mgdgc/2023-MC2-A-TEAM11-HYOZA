//
//  TodayView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/07.
//

import SwiftUI
import CoreData

struct TodayView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var isQuestionBoxViewTapped: Bool = false
    
    @State var openDegree: Double = 90
    @State var closedDegree: Double = 0
    
    @State var easyQuestions: [QuerySentence] = QuerySentenceManager.shared.filtered(difficulty: .easy)
    @State var hardQuestions: [QuerySentence] = QuerySentenceManager.shared.filtered(difficulty: .hard)
    @State var isContinueIconSmall: Bool = false
    @State var continueText: String? = "연속 작성 12일 돌파!"
    @State var continueTextOpacity: Double = 1.0
    @State var isContinueIconAnimating: Bool = false
    @State var continuousDayCount: Int = 0
    
    var body: some View {
        ZStack {
            Color.backGroundWhite
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                Text(Date().dateOnlyString)
                    .font(.system(.footnote))
                HStack {
                    Text("오늘의 질문")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.textBlack)
                    Spacer()
                    ContinueIconView(text: $continueText, textOpacity: $continueTextOpacity, continuousDayCount: $continuousDayCount)
                        .onTapGesture {
                            if !isContinueIconAnimating {
                                makeCoutinueIconLargeAndSmall()
                            }
                        }
                }
                Spacer()
                ZStack {
                    if isQuestionBoxViewTapped {
                        CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                            QuestionCardView(openDegree: $openDegree, closedDegree: $closedDegree,  easyQuestions: $easyQuestions, hardQuestions: $hardQuestions)
                        }
                    } else {
                        CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
                            QuestionBoxView(easyQuestions: $easyQuestions, hardQuestions: $hardQuestions, isQuestionBoxViewTapped: $isQuestionBoxViewTapped)
                        }
                        .onTapGesture {
                            self.isQuestionBoxViewTapped.toggle()
                        }
                    }
                }
                Spacer()
            }
            .padding(20)
            
        }
        .onAppear() {
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
    }
    
    func makeContinueIconSmall() {
        self.continueTextOpacity = 0
        withAnimation(.easeInOut(duration: 0.7)) {
            self.continueText = nil
        }
    }
    
    func makeContinueIconLarge() {
        withAnimation(.easeInOut(duration: 0.7)) {
            self.continueText = "연속 작성 12일째 돌파!"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.continueTextOpacity = 1
        }
    }
    
    func makeCoutinueIconLargeAndSmall() {
        self.isContinueIconAnimating = true
        makeContinueIconLarge()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            makeContinueIconSmall()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.isContinueIconAnimating = false
            }
        }
    }
}

struct ContinueIconView: View {
    @Binding var text: String?
    @Binding var textOpacity: Double
    @Binding var continuousDayCount: Int
    
    var body: some View {
        CardView(cornerRadius: 16, shadowColor: .black.opacity(0.05), shadowRadius: 12) {
            HStack {
//                Image(systemName: "flame.fill")
                switch continuousDayCount {
                case 0:
                    Text("🤍")
                case 1..<4:
                    Text("💛")
                case 4..<8:
                    Text("🧡")
                case 7..<14:
                    Text("❤️")
                default:
                    Text("❤️‍🔥")
                }
                if let text {
                    Text(text)
                        .font(.caption)
                        .bold()
                        .opacity(textOpacity)
                }
            }
        }
        .onAppear() {
            continuousDayCount = AttendanceManager().isAttending ? AttendanceManager().getAttendanceDay() : 0
        }
        
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
